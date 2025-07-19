import '../../domain/entities/chat_room.dart';
import '../../domain/entities/message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatRoomsLoaded extends ChatState {
  final List<ChatRoom> chatRooms;
  ChatRoomsLoaded(this.chatRooms);
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  final String chatRoomId;
  final Map<String, bool> typingUsers;

  MessagesLoaded({
    required this.messages,
    required this.chatRoomId,
    this.typingUsers = const {},
  });
}

class MessageSent extends ChatState {
  final Message message;
  MessageSent(this.message);
}

class MessageDeleted extends ChatState {
  final String messageId;
  MessageDeleted(this.messageId);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
