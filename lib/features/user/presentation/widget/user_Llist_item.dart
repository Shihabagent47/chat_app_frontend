import 'package:chat_app_user/features/user/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onTap;

  const UserListItem({Key? key, required this.user, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
          ),
        ),
        title: Text(user.firstName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(user.email), Text('@${user.firstName}')],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
