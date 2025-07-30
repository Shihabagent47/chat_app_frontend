import 'package:flutter/material.dart';

import '../../domain/entities/chat_room.dart';
import 'chat_room_avatar.dart';

class ChatRoomListItem extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String? lastMessageText;
  final String? lastMessageSender;
  final bool isPinned;
  final bool isArchived;
  final bool isMuted;

  const ChatRoomListItem({
    Key? key,
    required this.chatRoom,
    required this.onTap,
    this.onLongPress,
    this.lastMessageText,
    this.lastMessageSender,
    this.isPinned = false,
    this.isArchived = false,
    this.isMuted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPinned ? Colors.grey.shade50 : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          splashColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Avatar
                ChatRoomAvatar(
                  avatarUrl: chatRoom.avatarUrl,
                  name: chatRoom.name,
                  type: chatRoom.type.name,
                  participantCount: chatRoom.participantIds.length,
                ),
                const SizedBox(width: 12),

                // Chat Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Time Row
                      Row(
                        children: [
                          if (isPinned)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.push_pin,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              chatRoom.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    chatRoom.unreadCount > 0
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                color:
                                    isArchived
                                        ? Colors.grey.shade600
                                        : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatTime(chatRoom.lastActivity),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  chatRoom.unreadCount > 0
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade600,
                              fontWeight:
                                  chatRoom.unreadCount > 0
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Last Message and Status Row
                      Row(
                        children: [
                          Expanded(child: _buildLastMessage()),
                          _buildTrailingIcons(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLastMessage() {
    String displayText = '';

    if (lastMessageText != null) {
      if (chatRoom.type == 'group' && lastMessageSender != null) {
        displayText = '$lastMessageSender: $lastMessageText';
      } else {
        displayText = lastMessageText!;
      }
    } else if (chatRoom.description?.isNotEmpty == true) {
      displayText = chatRoom.description!;
    } else {
      displayText = 'No messages yet';
    }

    return Text(
      displayText,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
        fontWeight:
            chatRoom.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildTrailingIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMuted)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.volume_off,
              size: 16,
              color: Colors.grey.shade500,
            ),
          ),
        if (chatRoom.unreadCount > 0)
          Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isMuted ? Colors.grey.shade400 : Colors.red.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            child: Text(
              chatRoom.unreadCount > 99 ? '99+' : '${chatRoom.unreadCount}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      final hour = time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[time.weekday - 1];
    } else {
      return '${time.day}/${time.month}/${time.year.toString().substring(2)}';
    }
  }
}
