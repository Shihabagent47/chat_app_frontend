import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatus;
  final GetCurrentUserUseCase getCurrentUser;
  final LoginUseCase login;
  final RegisterUseCase register;
  final LogoutUseCase logout;

  AuthBloc({
    required this.checkAuthStatus,
    required this.getCurrentUser,
    required this.login,
    required this.register,
    required this.logout,
  }) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthUserRequested>(_onAuthUserRequested);
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final authResult = await checkAuthStatus(NoParams());

    if (authResult.isLeft()) {
      emit(const AuthState.unauthenticated());
      return;
    }

    final isAuthenticated = authResult.fold((l) => false, (r) => r);

    if (isAuthenticated) {
      final userResult = await getCurrentUser(NoParams());
      if (emit.isDone) return;

      userResult.fold(
        (failure) => emit(const AuthState.unauthenticated()),
        (user) => emit(AuthState.authenticated(user)),
      );
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('Login requested');
    emit(const AuthState.loading());
    final result = await login(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthState.unauthenticated(message: failure.message)),
      (authResponse) => emit(AuthState.authenticated(authResponse.user)),
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await register(
      RegisterParams(
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthState.unauthenticated(message: failure.message)),
      (authResponse) => emit(AuthState.authenticated(authResponse.user)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    await logout(NoParams());
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onAuthUserRequested(
    AuthUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('User requested');

    await _loadCurrentUser(emit);
  }

  Future<void> _loadCurrentUser(Emitter<AuthState> emit) async {
    final result = await getCurrentUser(NoParams());
    print('User result: $result');
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user)),
    );
  }
}
