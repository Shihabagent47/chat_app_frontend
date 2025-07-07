import 'package:chat_app_user/features/home/data/models/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsiveNavigation extends StatelessWidget {
  final List<NavigationItem> items;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final Widget child;

  const ResponsiveNavigation({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 768;

        if (isDesktop) {
          return _buildDesktopLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              onItemSelected(index);
              // Navigate using GoRouter
              // GoRouter.of(context).go(items[index].route);
            },
            labelType: NavigationRailLabelType.all,
            destinations:
                items.map((item) {
                  return NavigationRailDestination(
                    icon: _getIcon(item.icon),
                    selectedIcon: _getIcon(item.icon, selected: true),
                    label: Text(item.label),
                  );
                }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          onItemSelected(index);
          // Navigate using GoRouter
          //  GoRouter.of(context).go(items[index].route);
        },
        items:
            items.map((item) {
              return BottomNavigationBarItem(
                icon: _getIcon(item.icon),
                activeIcon: _getIcon(item.icon, selected: true),
                label: item.label,
              );
            }).toList(),
      ),
    );
  }

  Widget _getIcon(String iconName, {bool selected = false}) {
    final iconData = _getIconData(iconName);
    return Icon(iconData, color: selected ? Colors.blue : Colors.grey);
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'message-circle':
        return Icons.chat;
      case 'user':
        return Icons.person;
      default:
        return Icons.help;
    }
  }
}
