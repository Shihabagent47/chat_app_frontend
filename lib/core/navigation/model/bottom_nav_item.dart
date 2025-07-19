import 'package:flutter/material.dart';
import '../routing/route_names.dart';

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

class BottomNavItems {
  static List<BottomNavItem> items = [
    BottomNavItem(
      icon: Icons.chat_outlined,
      activeIcon: Icons.chat,
      label: 'Chat',
      route: RouteNames.chatList,
    ),
    const BottomNavItem(
      icon: Icons.group_outlined,
      activeIcon: Icons.group,
      label: 'Users',
      route: RouteNames.userList,
    ),
    const BottomNavItem(
      icon: Icons.person_outlined,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile',
    ),
    const BottomNavItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      label: 'Notifications',
      route: '/notifications',
    ),
  ];
}
