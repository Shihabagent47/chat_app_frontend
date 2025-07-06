import 'package:chat_app_user/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.chatRoomId,
    required super.content,
    required super.type,
    required super.status,
    required super.timestamp,
    super.replyToId,
    super.metadata,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['senderId'],
      chatRoomId: json['chatRoomId'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      replyToId: json['replyToId'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'chatRoomId': chatRoomId,
      'content': content,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'replyToId': replyToId,
      'metadata': metadata,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      senderId: message.senderId,
      chatRoomId: message.chatRoomId,
      content: message.content,
      type: message.type,
      status: message.status,
      timestamp: message.timestamp,
      replyToId: message.replyToId,
      metadata: message.metadata,
    );
  }
}
