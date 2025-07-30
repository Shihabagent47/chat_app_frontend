import 'package:chat_app_user/features/user/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../../../shared/widgets/common/user_avatar.dart';

class UserListItem extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onTap;
  final bool showOnlineStatus;
  final bool isOnline;
  final Widget? trailing;
  final String? subtitle;

  const UserListItem({
    Key? key,
    required this.user,
    required this.onTap,
    this.showOnlineStatus = true,
    this.isOnline = false,
    this.trailing,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                UserAvatar(
                  profilePhoto: user.profilePhoto,
                  firstName: user.firstName,
                  lastName: user.lastName,
                  isOnline: showOnlineStatus ? isOnline : false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}'.trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_getSubtitle().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          _getSubtitle(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSubtitle() {
    if (subtitle != null) return subtitle!;
    if (user.about?.isNotEmpty == true) return user.about!;
    return user.email;
  }
}
