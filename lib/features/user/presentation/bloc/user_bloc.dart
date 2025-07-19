import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SearchUsers>(_onSearchUsers);
    on<LoadUserDetails>(_onLoadUserDetails);
    on<ClearUserDetails>(_onClearUserDetails);
    on<RefreshUsers>(_onRefreshUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final users = await _userRepository.getUsers(
        forceRefresh: event.forceRefresh,
      );
      emit(UserLoaded(users: users, filteredUsers: users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      try {
        final filteredUsers = await _userRepository.searchUsers(event.query);
        emit(
          currentState.copyWith(
            filteredUsers: filteredUsers,
            searchQuery: event.query,
          ),
        );
      } catch (e) {
        emit(UserError(e.toString()));
      }
    }
  }

  Future<void> _onLoadUserDetails(
    LoadUserDetails event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserDetailsLoading());
      final user = await _userRepository.getUserById(
        event.userId,
        forceRefresh: event.forceRefresh,
      );
      emit(UserDetailsLoaded(user));
    } catch (e) {
      emit(UserDetailsError(e.toString()));
    }
  }

  void _onClearUserDetails(ClearUserDetails event, Emitter<UserState> emit) {
    if (state is UserLoaded) {
      emit(state as UserLoaded);
    } else {
      emit(UserInitial());
    }
  }

  Future<void> _onRefreshUsers(
    RefreshUsers event,
    Emitter<UserState> emit,
  ) async {
    add(const LoadUsers(forceRefresh: true));
  }
}
