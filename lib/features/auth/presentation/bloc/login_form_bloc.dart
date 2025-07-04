import 'package:chat_app_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app_user/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Login Form Events
abstract class LoginFormEvent extends Equatable {
  const LoginFormEvent();

  @override
  List<Object> get props => [];
}

class LoginFormEmailChanged extends LoginFormEvent {
  final String email;

  const LoginFormEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class LoginFormPasswordChanged extends LoginFormEvent {
  final String password;

  const LoginFormPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class LoginFormSubmitted extends LoginFormEvent {}

// Login Form States
class LoginFormState extends Equatable {
  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.isValid = false,
  });

  final String email;
  final String password;
  final bool isLoading;
  final bool isValid;

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? isValid,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [email, password, isLoading, isValid];
}

// Login Form Bloc
class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final AuthBloc authBloc;

  LoginFormBloc({required this.authBloc}) : super(const LoginFormState()) {
    on<LoginFormEmailChanged>(_onEmailChanged);
    on<LoginFormPasswordChanged>(_onPasswordChanged);
    on<LoginFormSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    LoginFormEmailChanged event,
    Emitter<LoginFormState> emit,
  ) {
    final newState = state.copyWith(email: event.email);
    emit(newState.copyWith(isValid: _isFormValid(newState)));
  }

  void _onPasswordChanged(
    LoginFormPasswordChanged event,
    Emitter<LoginFormState> emit,
  ) {
    final newState = state.copyWith(password: event.password);
    emit(newState.copyWith(isValid: _isFormValid(newState)));
  }

  void _onSubmitted(LoginFormSubmitted event, Emitter<LoginFormState> emit) {
    if (state.isValid) {
      emit(state.copyWith(isLoading: true));

      authBloc.add(
        AuthLoginRequested(email: state.email, password: state.password),
      );
    }
  }

  bool _isFormValid(LoginFormState state) {
    return state.email.isNotEmpty &&
        state.email.contains('@') &&
        state.password.isNotEmpty &&
        state.password.length >= 6;
  }
}
