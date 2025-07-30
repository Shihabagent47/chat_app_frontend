import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? profilePhoto;
  final String firstName;
  final String lastName;
  final bool isOnline;
  final double radius;

  const UserAvatar({
    Key? key,
    this.profilePhoto,
    required this.firstName,
    required this.lastName,
    this.isOnline = false,
    this.radius = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: _getAvatarColor(),
          backgroundImage:
              profilePhoto != null ? NetworkImage(profilePhoto!) : null,
          child:
              profilePhoto == null
                  ? Text(
                    _getInitials(),
                    style: TextStyle(
                      fontSize: radius * 0.7,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                  : null,
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: radius * 0.35,
              height: radius * 0.35,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  String _getInitials() {
    String initials = '';
    if (firstName.isNotEmpty) initials += firstName[0].toUpperCase();
    if (lastName.isNotEmpty) initials += lastName[0].toUpperCase();
    return initials.isEmpty ? '?' : initials;
  }

  Color _getAvatarColor() {
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
      Colors.red.shade400,
    ];
    final hash = (firstName + lastName).hashCode;
    return colors[hash.abs() % colors.length];
  }
}
