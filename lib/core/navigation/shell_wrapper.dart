import 'package:chat_app_user/core/navigation/routing/navigation_helper.dart';
import 'package:chat_app_user/core/navigation/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'bloc/navigation_bloc.dart';
import 'model/bottom_nav_item.dart';

class ShellWrapper extends StatelessWidget {
  final Widget child;

  const ShellWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _getCurrentIndex(context),
            onTap: (index) => _onTabTapped(context, index),
            items:
                BottomNavItems.items
                    .map(
                      (item) => BottomNavigationBarItem(
                        icon: Icon(item.icon),
                        activeIcon: Icon(item.activeIcon),
                        label: item.label,
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith(RouteNames.chatList)) return 0;
    if (location.startsWith(RouteNames.userList)) return 1;
    if (location.startsWith('/profile')) return 2;
    if (location.startsWith('/notifications')) return 3;

    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    context.read<NavigationBloc>().add(TabChanged(index));

    switch (index) {
      case 0:
        NavigationHelper.goToChatList(context);
        break;
      case 1:
        NavigationHelper.goToUserList(context);
        break;
      case 2:
        context.go('/profile');
        break;
      case 3:
        context.go('/notifications');
        break;
    }
  }
}
