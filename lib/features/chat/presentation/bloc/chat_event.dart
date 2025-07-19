import '../../domain/entities/message.dart';

abstract class ChatEvent {}

class LoadChatRooms extends ChatEvent {}

class LoadMessages extends ChatEvent {
  final String chatRoomId;
  LoadMessages(this.chatRoomId);
}

class SendMessage extends ChatEvent {
  final String chatRoomId;
  final String content;
  final String? mediaPath;
  final String? mediaType;

  SendMessage({
    required this.chatRoomId,
    required this.content,
    this.mediaPath,
    this.mediaType,
  });
}

class DeleteMessage extends ChatEvent {
  final String messageId;
  DeleteMessage(this.messageId);
}

class MarkAsRead extends ChatEvent {
  final String chatRoomId;
  final String messageId;

  MarkAsRead({required this.chatRoomId, required this.messageId});
}

class MessageReceived extends ChatEvent {
  final Message message;
  MessageReceived(this.message);
}

class UserTyping extends ChatEvent {
  final String chatRoomId;
  final String userId;
  final bool isTyping;

  UserTyping({
    required this.chatRoomId,
    required this.userId,
    required this.isTyping,
  });
}
