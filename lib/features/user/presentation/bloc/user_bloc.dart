import 'package:bloc/bloc.dart';
import 'package:chat_app_user/features/user/domain/entities/user_entity.dart';
import 'package:chat_app_user/features/user/domain/repositories/user_repository.dart';
import 'package:chat_app_user/features/user/domain/usecases/get_users_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_user_details_use_case.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsers;
  final GetUserDetailsUseCase getUserDetails;

  UserBloc({required this.getUserDetails, required this.getUsers})
    : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUserDetails>(_onLoadUserDetails);
    on<ClearUserDetails>(_onClearUserDetails);
    on<RefreshUsers>(_onRefreshUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final users = await getUsers(NoParams());
      users.fold(
        (failure) => emit(UserError(failure.message)),
        (users) =>
            emit(UserLoaded(users: users.data, filteredUsers: users.data)),
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUserDetails(
    LoadUserDetails event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserDetailsLoading());
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
