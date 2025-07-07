import 'package:chat_app_user/features/home/data/models/navigation_item.dart';

abstract class NavigationRepository {
  List<NavigationItem> getNavigationItems();
  Future<void> updateSelectedItem(int index);
}

class NavigationRepositoryImpl implements NavigationRepository {
  final List<NavigationItem> _items = [
    const NavigationItem(
      label: 'Home',
      icon: 'home',
      route: '/home',
      isSelected: true,
    ),
    const NavigationItem(label: 'Chat', icon: 'message-circle', route: '/chat'),
    const NavigationItem(label: 'Profile', icon: 'user', route: '/profile'),
  ];

  @override
  List<NavigationItem> getNavigationItems() {
    return List.from(_items);
  }

  @override
  Future<void> updateSelectedItem(int index) async {
    // Simulate API call or local storage update
    await Future.delayed(const Duration(milliseconds: 100));

    for (int i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isSelected: i == index);
    }
  }
}
