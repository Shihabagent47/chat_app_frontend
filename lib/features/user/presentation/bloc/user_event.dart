part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {
  final bool forceRefresh;

  const LoadUsers({this.forceRefresh = false});

  @override
  List<Object> get props => [forceRefresh];
}

class SearchUsers extends UserEvent {
  final String query;

  const SearchUsers(this.query);

  @override
  List<Object> get props => [query];
}

class LoadUserDetails extends UserEvent {
  final String userId;
  final bool forceRefresh;

  const LoadUserDetails(this.userId, {this.forceRefresh = false});

  @override
  List<Object> get props => [userId, forceRefresh];
}

class ClearUserDetails extends UserEvent {}

class RefreshUsers extends UserEvent {}
