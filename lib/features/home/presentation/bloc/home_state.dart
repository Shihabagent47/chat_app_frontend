import 'package:chat_app_user/features/home/data/models/navigation_item.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<NavigationItem> navigationItems;
  final int selectedIndex;

  HomeLoaded({required this.navigationItems, required this.selectedIndex});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
