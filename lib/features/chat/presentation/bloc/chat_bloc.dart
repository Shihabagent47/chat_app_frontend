import 'package:chat_app_user/features/chat/domain/usecases/mark_as_read.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/send_message_params.dart';
import '../../domain/usecases/get_chat_room.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/delete_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final MarkAsReadUseCase markAsReadUseCase;

  ChatBloc({
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.deleteMessageUseCase,
    required this.markAsReadUseCase,
  }) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<MarkAsRead>(_onMarkAsRead);
    on<MessageReceived>(_onMessageReceived);
    on<UserTyping>(_onUserTyping);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final result = await getMessagesUseCase(
        GetMessagesParams(chatRoomId: event.chatRoomId),
      );
      result.fold(
        (failure) => emit(ChatError('Failed to load messages: $failure')),
        (messages) => emit(
          MessagesLoaded(messages: messages, chatRoomId: event.chatRoomId),
        ),
      );
    } catch (e) {
      emit(ChatError('Failed to load messages: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
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
        (failure) => emit(ChatError('Failed to send message: $failure')),
        (message) => emit(MessageSent(message)),
      );
    } catch (e) {
      emit(ChatError('Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final result = await deleteMessageUseCase(
        DeleteMessageParams(messageId: event.messageId),
      );
      result.fold(
        (failure) => emit(ChatError('Failed to delete message: $failure')),
        (_) => emit(MessageDeleted(event.messageId)),
      );
    } catch (e) {
      emit(ChatError('Failed to delete message: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAsRead(MarkAsRead event, Emitter<ChatState> emit) async {
    try {
      final result = await markAsReadUseCase(
        MarkAsReadParams(
          chatRoomId: event.chatRoomId,
          messageId: event.messageId,
        ),
      );
      result.fold(
        (failure) => emit(ChatError('Failed to mark as read: $failure')),
        (_) => {}, // Success - no specific state change needed
      );
    } catch (e) {
      emit(ChatError('Failed to mark as read: ${e.toString()}'));
    }
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    final currentState = state;
    if (currentState is MessagesLoaded) {
      final updatedMessages = [...currentState.messages, event.message];
      emit(
        MessagesLoaded(
          messages: updatedMessages,
          chatRoomId: currentState.chatRoomId,
          typingUsers: currentState.typingUsers,
        ),
      );
    }
  }

  void _onUserTyping(UserTyping event, Emitter<ChatState> emit) {
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

      emit(
        MessagesLoaded(
          messages: currentState.messages,
          chatRoomId: currentState.chatRoomId,
          typingUsers: updatedTypingUsers,
        ),
      );
    }
  }
}
