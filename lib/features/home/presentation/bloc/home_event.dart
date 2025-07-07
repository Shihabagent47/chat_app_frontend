abstract class HomeEvent {}

class HomeInitialized extends HomeEvent {}

class NavigationItemSelected extends HomeEvent {
  final int index;
  NavigationItemSelected(this.index);
}
