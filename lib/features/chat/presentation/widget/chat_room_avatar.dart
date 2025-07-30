import 'package:flutter/material.dart';

class ChatRoomAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String type; // 'direct', 'group', 'channel', etc.
  final double radius;
  final int? participantCount;

  const ChatRoomAvatar({
    Key? key,
    this.avatarUrl,
    required this.name,
    required this.type,
    this.radius = 24,
    this.participantCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: _getAvatarColor(),
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null ? _buildDefaultAvatar() : null,
        ),
        if (_shouldShowTypeIndicator())
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTypeIcon(),
                size: radius * 0.4,
                color: _getTypeColor(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    if (type == 'group' || type == 'channel') {
      return Icon(
        type == 'group' ? Icons.group : Icons.tag,
        size: radius * 0.8,
        color: Colors.white,
      );
    }

    return Text(
      _getInitials(),
      style: TextStyle(
        fontSize: radius * 0.7,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  String _getInitials() {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color _getAvatarColor() {
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
      Colors.red.shade400,
      Colors.indigo.shade400,
      Colors.pink.shade400,
    ];
    final hash = name.hashCode;
    return colors[hash.abs() % colors.length];
  }

  bool _shouldShowTypeIndicator() {
    return type == 'group' && participantCount != null && participantCount! > 2;
  }

  IconData _getTypeIcon() {
    switch (type) {
      case 'group':
        return Icons.group;
      case 'channel':
        return Icons.campaign;
      case 'broadcast':
        return Icons.volume_up;
      default:
        return Icons.person;
    }
  }

  Color _getTypeColor() {
    switch (type) {
      case 'group':
        return Colors.blue;
      case 'channel':
        return Colors.orange;
      case 'broadcast':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
