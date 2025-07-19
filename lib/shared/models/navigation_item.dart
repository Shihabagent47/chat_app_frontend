class NavigationItem {
  final String label;
  final String icon;
  final String route;
  final bool isSelected;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
    this.isSelected = false,
  });

  NavigationItem copyWith({
    String? label,
    String? icon,
    String? route,
    bool? isSelected,
  }) {
    return NavigationItem(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
