import 'package:chat_app_user/features/chat/domain/usecases/mark_as_read.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final GetChatRoomsUseCase getChatRoomsUseCase;

  ChatBloc({
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.deleteMessageUseCase,
    required this.markAsReadUseCase,
    required this.getChatRoomsUseCase,
  }) : super(ChatInitial()) {
    on<LoadChatRooms>(_onLoadChatRooms);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<MarkAsRead>(_onMarkAsRead);
    on<MessageReceived>(_onMessageReceived);
    on<UserTyping>(_onUserTyping);
  }

  Future<void> _onLoadChatRooms(
    LoadChatRooms event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final chatRooms = await getChatRoomsUseCase();
      chatRooms.fold(
        (failure) => emit(ChatError('Failed to load chat rooms')),
        (chatRooms) => emit(ChatRoomsLoaded(chatRooms)),
      );
    } catch (e) {
      emit(ChatError('Failed to load chat rooms: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages = await getMessagesUseCase(event.chatRoomId);
      // emit(MessagesLoaded(messages: messages, chatRoomId: event.chatRoomId));
    } catch (e) {
      emit(ChatError('Failed to load messages: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // final message = await sendMessageUseCase(
      //   SendMessageParams(
      //     chatRoomId: event.chatRoomId,
      //     content: event.content,
      //     mediaPath: event.mediaPath,
      //     mediaType: event.mediaType,
      //   ),
      // );
      // emit(MessageSent(message));
    } catch (e) {
      emit(ChatError('Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await deleteMessageUseCase(event.messageId);
      emit(MessageDeleted(event.messageId));
    } catch (e) {
      emit(ChatError('Failed to delete message: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAsRead(MarkAsRead event, Emitter<ChatState> emit) async {
    try {
      // await markAsReadUseCase(
      //   MarkAsReadParams(
      //     chatRoomId: event.chatRoomId,
      //     messageId: event.messageId,
      //   ),
      // );
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
