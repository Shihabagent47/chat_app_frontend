import 'package:equatable/equatable.dart';

enum ChatRoomType { private, group }

class ChatRoom extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final ChatRoomType type;
  final List<String> participantIds;
  final String? lastMessageId;
  final DateTime lastActivity;
  final DateTime createdAt;
  final int unreadCount;
  final Map<String, dynamic>? metadata;

  const ChatRoom({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
    required this.type,
    required this.participantIds,
    this.lastMessageId,
    required this.lastActivity,
    required this.createdAt,
    required this.unreadCount,
    this.metadata,
  });

  ChatRoom copyWith({
    String? id,
    String? name,
    String? description,
    String? avatarUrl,
    ChatRoomType? type,
    List<String>? participantIds,
    String? lastMessageId,
    DateTime? lastActivity,
    DateTime? createdAt,
    int? unreadCount,
    Map<String, dynamic>? metadata,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastActivity: lastActivity ?? this.lastActivity,
      createdAt: createdAt ?? this.createdAt,
      unreadCount: unreadCount ?? this.unreadCount,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    avatarUrl,
    type,
    participantIds,
    lastMessageId,
    lastActivity,
    createdAt,
    unreadCount,
    metadata,
  ];
}
