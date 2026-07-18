import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/generic_list_bloc.dart';
import '../../../../core/model/paginated_list_response.dart';
import '../../../../core/model/query_params.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/models/chat_message_qury_params.dart';
import '../../data/models/send_message_params.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/delete_message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/mark_as_read.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends GenericListBloc<Message> {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final ChatRemoteDataSource chatRemoteDataSource;

  String? _currentChatRoomId;
  StreamSubscription<Message>? _messageSubscription;
  StreamSubscription<List<String>>? _typingSubscription;
  List<String> _previousTypingUsers = [];

  ChatBloc({
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.deleteMessageUseCase,
    required this.markAsReadUseCase,
    required this.chatRemoteDataSource,
  }) : super() {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<RetryMessage>(_onRetryMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<MarkAsRead>(_onMarkAsRead);
    on<MessageReceived>(_onMessageReceived);
    on<UserTyping>(_onUserTyping);
  }

  @override
  Future<PaginatedListResponse<Message>> fetchData(QueryParams queryParams) async {
    if (_currentChatRoomId == null) throw Exception('Chat room ID not set');
    final params = GetMessagesParams(
      chatRoomId: _currentChatRoomId!,
      queryParams: queryParams as ChatMessageQueryParams,
    );
    final result = await getMessagesUseCase(params);
    return result.fold(
      (failure) => throw Exception(failure.toString()),
      (response) => response,
    );
  }

  @override
  QueryParams getDefaultQueryParams() => ChatMessageQueryParams(page: 1, limit: 20);

  @override
  QueryParams getNextPageQueryParams(QueryParams currentParams, int nextPage) {
    final chatParams = currentParams as ChatMessageQueryParams;
    return ChatMessageQueryParams(page: nextPage, limit: chatParams.limit);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<GenericListState<Message>> emit,
  ) async {
    _currentChatRoomId = event.chatRoomId;

    // Cancel any prior room's subscriptions before subscribing to new room
    await _messageSubscription?.cancel();
    await _typingSubscription?.cancel();
    _previousTypingUsers = [];

    // Load initial page via HTTP
    await super.onLoadList(
      LoadList(queryParams: event.queryParams, refresh: event.refresh),
      emit,
    );

    // Wrap ListLoaded into the chat-specific MessagesLoaded
    if (state is ListLoaded<Message>) {
      final s = state as ListLoaded<Message>;
      emit(MessagesLoaded(
        items: s.items,
        meta: s.meta,
        hasReachedMax: s.hasReachedMax,
        chatRoomId: event.chatRoomId,
        currentQueryParams: s.currentQueryParams,
      ));
    }

    // Subscribe to socket stream for incoming messages
    _messageSubscription = chatRemoteDataSource
        .watchMessages(event.chatRoomId)
        .listen((message) => add(MessageReceived(message)));

    // Subscribe to typing indicators
    _typingSubscription = chatRemoteDataSource
        .watchTypingUsers(event.chatRoomId)
        .listen((current) {
      final prev = Set<String>.from(_previousTypingUsers);
      final now = Set<String>.from(current);
      for (final id in now.difference(prev)) {
        add(UserTyping(userId: id, isTyping: true));
      }
      for (final id in prev.difference(now)) {
        add(UserTyping(userId: id, isTyping: false));
      }
      _previousTypingUsers = current;
    });
  }

  // ─── Optimistic send ──────────────────────────────────────────────────────

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<GenericListState<Message>> emit,
  ) async {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    // Build the optimistic message with a local temp id
    final optimistic = SendMessageParams(
      chatRoomId: event.chatRoomId,
      senderId: event.senderId,
      content: event.content,
      mediaPath: event.mediaPath,
      mediaType: event.mediaType,
      status: MessageStatus.sending,
    );

    // 1. Show immediately
    emit(currentState.copyWith(
      messages: [...currentState.items, optimistic],
    ));

    // 2. Fire HTTP
    final result = await sendMessageUseCase(optimistic);

    final afterState = state;
    if (afterState is! MessagesLoaded) return;

    result.fold(
      (failure) {
        // Mark optimistic message as failed
        emit(afterState.copyWith(
          messages: afterState.items.map((m) {
            return m.id == optimistic.id
                ? m.copyWith(status: MessageStatus.failed)
                : m;
          }).toList(),
        ));
      },
      (confirmed) {
        // Replace optimistic with confirmed, then dedup in case socket
        // already echoed back the server message
        final replaced = afterState.items.map((m) {
          return m.id == optimistic.id ? confirmed : m;
        }).toList();

        final seen = <String>{};
        final deduped = replaced.where((m) => seen.add(m.id)).toList();

        emit(afterState.copyWith(messages: deduped));
      },
    );
  }

  // ─── Retry a failed message ───────────────────────────────────────────────

  Future<void> _onRetryMessage(
    RetryMessage event,
    Emitter<GenericListState<Message>> emit,
  ) async {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    Message? failed;
    try {
      failed = currentState.items.firstWhere(
        (m) => m.id == event.tempId && m.status == MessageStatus.failed,
      );
    } catch (_) {
      return;
    }

    // Reset to sending
    emit(currentState.copyWith(
      messages: currentState.items.map((m) {
        return m.id == event.tempId ? m.copyWith(status: MessageStatus.sending) : m;
      }).toList(),
    ));

    final result = await sendMessageUseCase(failed);

    final afterState = state;
    if (afterState is! MessagesLoaded) return;

    result.fold(
      (failure) {
        emit(afterState.copyWith(
          messages: afterState.items.map((m) {
            return m.id == event.tempId
                ? m.copyWith(status: MessageStatus.failed)
                : m;
          }).toList(),
        ));
      },
      (confirmed) {
        final replaced = afterState.items.map((m) {
          return m.id == event.tempId ? confirmed : m;
        }).toList();
        final seen = <String>{};
        emit(afterState.copyWith(
          messages: replaced.where((m) => seen.add(m.id)).toList(),
        ));
      },
    );
  }

  // ─── Optimistic delete ────────────────────────────────────────────────────

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<GenericListState<Message>> emit,
  ) async {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    Message? toDelete;
    try {
      toDelete = currentState.items.firstWhere((m) => m.id == event.messageId);
    } catch (_) {
      return;
    }

    // 1. Remove immediately
    emit(currentState.copyWith(
      messages: currentState.items.where((m) => m.id != event.messageId).toList(),
    ));

    // 2. Fire HTTP
    final result = await deleteMessageUseCase(
      DeleteMessageParams(messageId: event.messageId),
    );

    result.fold(
      (failure) {
        // Restore the message in its original position on failure
        final afterState = state;
        if (afterState is! MessagesLoaded) return;
        final restored = [...afterState.items, toDelete!]
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        emit(afterState.copyWith(messages: restored));
      },
      (_) {},
    );
  }

  // ─── Mark as read (fire and forget) ──────────────────────────────────────

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<GenericListState<Message>> emit,
  ) async {
    await markAsReadUseCase(
      MarkAsReadParams(
        chatRoomId: event.chatRoomId,
        messageId: event.messageId,
      ),
    );
  }

  // ─── Socket events ────────────────────────────────────────────────────────

  void _onMessageReceived(
    MessageReceived event,
    Emitter<GenericListState<Message>> emit,
  ) {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    // Dedup: ignore if this message was already added (e.g. socket echo of own send)
    if (currentState.items.any((m) => m.id == event.message.id)) return;

    emit(currentState.copyWith(
      messages: [...currentState.items, event.message],
    ));
  }

  void _onUserTyping(
    UserTyping event,
    Emitter<GenericListState<Message>> emit,
  ) {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    final updated = Map<String, bool>.from(currentState.typingUsers);
    if (event.isTyping) {
      updated[event.userId] = true;
    } else {
      updated.remove(event.userId);
    }
    emit(currentState.copyWith(typingUsers: updated));
  }

  @override
  Future<void> close() async {
    await _messageSubscription?.cancel();
    await _typingSubscription?.cancel();
    return super.close();
  }
}