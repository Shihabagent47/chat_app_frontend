import 'package:equatable/equatable.dart';

enum MessageType { text, image, video, audio, file }

enum MessageStatus { sending, sent, delivered, read, failed }

class Message extends Equatable {
  final String id;
  final String senderId;
  final String chatRoomId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final String? replyToId;
  final Map<String, dynamic>? metadata;

  const Message({
    required this.id,
    required this.senderId,
    required this.chatRoomId,
    required this.content,
    required this.type,
    required this.status,
    required this.timestamp,
    this.replyToId,
    this.metadata,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? chatRoomId,
    String? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    String? replyToId,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      replyToId: replyToId ?? this.replyToId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    senderId,
    chatRoomId,
    content,
    type,
    status,
    timestamp,
    replyToId,
    metadata,
  ];
}
