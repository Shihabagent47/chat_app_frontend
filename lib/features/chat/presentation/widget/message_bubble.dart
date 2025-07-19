import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final String? senderName;
  final String? senderAvatar;
  final Color? bubbleColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    this.senderName,
    this.senderAvatar,
    this.bubbleColor,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender name for group chats
          if (!isMe && senderName != null)
            Padding(
              padding: const EdgeInsets.only(left: 46, bottom: 2),
              child: Text(
                senderName!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),

          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar for non-me messages
              if (!isMe) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      senderAvatar != null ? NetworkImage(senderAvatar!) : null,
                  child:
                      senderAvatar == null
                          ? Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey[600],
                          )
                          : null,
                ),
                const SizedBox(width: 8),
              ],

              // Message bubble
              Flexible(
                child: GestureDetector(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          bubbleColor ??
                          (isMe
                              ? (isDark ? Colors.blue[700] : Colors.blue[600])
                              : (isDark ? Colors.grey[800] : Colors.grey[200])),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft:
                            isMe
                                ? const Radius.circular(16)
                                : const Radius.circular(4),
                        bottomRight:
                            isMe
                                ? const Radius.circular(4)
                                : const Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Message content
                        Text(
                          message.content,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isMe
                                    ? Colors.white
                                    : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Timestamp and status
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTime(message.timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    isMe
                                        ? Colors.white70
                                        : (isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600]),
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              _buildStatusIcon(message.status),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return Icon(Icons.check, size: 16, color: Colors.white70);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 16, color: Colors.white70);
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 16, color: Colors.blue[200]);
      case MessageStatus.failed:
        return Icon(Icons.error_outline, size: 16, color: Colors.red[300]);
      default:
        return const SizedBox.shrink();
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
    }
  }
}
