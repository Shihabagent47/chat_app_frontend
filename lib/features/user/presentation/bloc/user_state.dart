part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;
  final String searchQuery;

  const UserLoaded({
    required this.users,
    required this.filteredUsers,
    this.searchQuery = '',
  });

  UserLoaded copyWith({
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
    String? searchQuery,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [users, filteredUsers, searchQuery];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

class UserDetailsLoading extends UserState {}

class UserDetailsLoaded extends UserState {
  final UserEntity user;

  const UserDetailsLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserDetailsError extends UserState {
  final String message;

  const UserDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
