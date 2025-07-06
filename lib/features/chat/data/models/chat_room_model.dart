import 'package:chat_app_user/features/chat/domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  const ChatRoomModel({
    required super.id,
    required super.name,
    super.description,
    super.avatarUrl,
    required super.type,
    required super.participantIds,
    super.lastMessageId,
    required super.lastActivity,
    required super.createdAt,
    required super.unreadCount,
    super.metadata,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      avatarUrl: json['avatarUrl'],
      type: ChatRoomType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ChatRoomType.private,
      ),
      participantIds: List<String>.from(json['participantIds']),
      lastMessageId: json['lastMessageId'],
      lastActivity: DateTime.parse(json['lastActivity']),
      createdAt: DateTime.parse(json['createdAt']),
      unreadCount: json['unreadCount'] ?? 0,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatarUrl': avatarUrl,
      'type': type.toString().split('.').last,
      'participantIds': participantIds,
      'lastMessageId': lastMessageId,
      'lastActivity': lastActivity.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'unreadCount': unreadCount,
      'metadata': metadata,
    };
  }

  factory ChatRoomModel.fromEntity(ChatRoom chatRoom) {
    return ChatRoomModel(
      id: chatRoom.id,
      name: chatRoom.name,
      description: chatRoom.description,
      avatarUrl: chatRoom.avatarUrl,
      type: chatRoom.type,
      participantIds: chatRoom.participantIds,
      lastMessageId: chatRoom.lastMessageId,
      lastActivity: chatRoom.lastActivity,
      createdAt: chatRoom.createdAt,
      unreadCount: chatRoom.unreadCount,
      metadata: chatRoom.metadata,
    );
  }
}
