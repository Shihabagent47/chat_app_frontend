import 'package:chat_app_user/features/chat/domain/usecases/mark_as_read.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/generic_list_bloc.dart';
import '../../../../core/model/paginated_list_response.dart';
import '../../../../core/model/query_params.dart';
import '../../data/models/chat_message_qury_params.dart';
import '../../data/models/send_message_params.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/delete_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends GenericListBloc<Message> {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final MarkAsReadUseCase markAsReadUseCase;

  String? _currentChatRoomId;

  ChatBloc({
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.deleteMessageUseCase,
    required this.markAsReadUseCase,
  }) : super() {
    // Add chat-specific event handlers
    on<SendMessage>(_onSendMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<MarkAsRead>(_onMarkAsRead);
    on<MessageReceived>(_onMessageReceived);
    on<UserTyping>(_onUserTyping);
    on<LoadMessages>(_onLoadMessages);
  }

  // Implement required abstract methods from GenericListBloc
  @override
  Future<PaginatedListResponse<Message>> fetchData(
    QueryParams queryParams,
  ) async {
    if (_currentChatRoomId == null) {
      throw Exception('Chat room ID not set');
    }

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
  QueryParams getDefaultQueryParams() {
    return ChatMessageQueryParams(page: 1, limit: 20); // Adjust as needed
  }

  @override
  QueryParams getNextPageQueryParams(QueryParams currentParams, int nextPage) {
    final chatParams = currentParams as ChatMessageQueryParams;
    return ChatMessageQueryParams(
      page: nextPage,
      limit: chatParams.limit,
      // Copy other chat-specific parameters if any
    );
  }

  // Override the inherited _onLoadList to handle chat-specific logic
  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<GenericListState<Message>> emit,
  ) async {
    _currentChatRoomId = event.chatRoomId;

    // Convert to LoadList event and call parent handler
    final loadListEvent = LoadList(
      queryParams: event.queryParams,
      refresh: event.refresh,
    );

    await super.onLoadList(loadListEvent, emit);

    // Convert the emitted state to chat-specific state if needed
    if (state is ListLoaded<Message>) {
      final loadedState = state as ListLoaded<Message>;
      emit(
        MessagesLoaded(
          items: loadedState.items,
          meta: loadedState.meta,
          hasReachedMax: loadedState.hasReachedMax,
          chatRoomId: event.chatRoomId,
          currentQueryParams: loadedState.currentQueryParams,
        ),
      );
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<GenericListState<Message>> emit,
  ) async {
    try {
      final messageParams = SendMessageParams(
        chatRoomId: event.chatRoomId,
        content: event.content,
        mediaPath: event.mediaPath,
        mediaType: event.mediaType,
      );

      final result = await sendMessageUseCase(messageParams);
      result.fold(
        (failure) =>
            emit(ChatError(message: 'Failed to send message: $failure')),
        (message) => emit(MessageSent(message)),
      );
    } catch (e) {
      emit(ChatError(message: 'Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<GenericListState<Message>> emit,
  ) async {
    try {
      final result = await deleteMessageUseCase(
        DeleteMessageParams(messageId: event.messageId),
      );
      result.fold(
        (failure) =>
            emit(ChatError(message: 'Failed to delete message: $failure')),
        (_) => emit(MessageDeleted(event.messageId)),
      );
    } catch (e) {
      emit(ChatError(message: 'Failed to delete message: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<GenericListState<Message>> emit,
  ) async {
    try {
      final result = await markAsReadUseCase(
        MarkAsReadParams(
          chatRoomId: event.chatRoomId,
          messageId: event.messageId,
        ),
      );
      result.fold(
        (failure) =>
            emit(ChatError(message: 'Failed to mark as read: $failure')),
        (_) => {}, // Success - no specific state change needed
      );
    } catch (e) {
      emit(ChatError(message: 'Failed to mark as read: ${e.toString()}'));
    }
  }

  void _onMessageReceived(
    MessageReceived event,
    Emitter<GenericListState<Message>> emit,
  ) {
    final currentState = state;
    if (currentState is MessagesLoaded) {
      final updatedMessages = [...currentState.items, event.message];
      emit(currentState.copyWith(messages: updatedMessages));
    }
  }

  void _onUserTyping(
    UserTyping event,
    Emitter<GenericListState<Message>> emit,
  ) {
    final currentState = state;
    if (currentState is MessagesLoaded) {
      final updatedTypingUsers = Map<String, bool>.from(
        currentState.typingUsers,
      );
      if (event.isTyping) {
        updatedTypingUsers[event.userId] = true;
      } else {
        updatedTypingUsers.remove(event.userId);
      }

      emit(currentState.copyWith(typingUsers: updatedTypingUsers));
    }
  }
}
