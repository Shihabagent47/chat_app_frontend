import 'package:chat_app_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app_user/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Register Form Events
abstract class RegisterFormEvent extends Equatable {
  const RegisterFormEvent();

  @override
  List<Object> get props => [];
}

class RegisterFormEmailChanged extends RegisterFormEvent {
  final String email;

  const RegisterFormEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class RegisterFormPasswordChanged extends RegisterFormEvent {
  final String password;

  const RegisterFormPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class RegisterFormConfirmPasswordChanged extends RegisterFormEvent {
  final String confirmPassword;

  const RegisterFormConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class RegisterFormSubmitted extends RegisterFormEvent {}

// Register Form States
class RegisterFormState extends Equatable {
  const RegisterFormState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.isValid = false,
    this.errorMessage = '',
    this.firstName = '', // Assuming firstName is part of the state
    this.lastName = '', // Assuming lastName is part of the state
    this.phone = '', // Assuming phone is part of the state
  });

  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool isValid;
  final String errorMessage;
  final String firstName; // Assuming firstName is part of the state
  final String lastName; // Assuming lastName is part of the state
  final String phone; // Assuming phone is part of the state

  RegisterFormState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    bool? isValid,
    String? errorMessage,
    String? firstName, // Assuming firstName is part of the state
    String? lastName, // Assuming lastName is part of the state
    String? phone, // Assuming phone is part of the state
  }) {
    return RegisterFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      firstName:
          firstName ??
          this.firstName, // Assuming firstName is part of the state
      lastName:
          lastName ?? this.lastName, // Assuming lastName is part of the state
      phone: phone ?? this.phone, // Assuming phone is part of the state
    );
  }

  @override
  List<Object> get props => [
    email,
    password,
    confirmPassword,
    isLoading,
    isValid,
    errorMessage,
  ];
}

// Register Form Bloc
class RegisterFormBloc extends Bloc<RegisterFormEvent, RegisterFormState> {
  final AuthBloc authBloc;

  RegisterFormBloc({required this.authBloc})
    : super(const RegisterFormState()) {
    on<RegisterFormEmailChanged>(_onEmailChanged);
    on<RegisterFormPasswordChanged>(_onPasswordChanged);
    on<RegisterFormConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterFormSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    RegisterFormEmailChanged event,
    Emitter<RegisterFormState> emit,
  ) {
    final newState = state.copyWith(email: event.email);
    emit(newState.copyWith(isValid: _isFormValid(newState)));
  }

  void _onPasswordChanged(
    RegisterFormPasswordChanged event,
    Emitter<RegisterFormState> emit,
  ) {
    final newState = state.copyWith(password: event.password);
    emit(newState.copyWith(isValid: _isFormValid(newState)));
  }

  void _onConfirmPasswordChanged(
    RegisterFormConfirmPasswordChanged event,
    Emitter<RegisterFormState> emit,
  ) {
    final newState = state.copyWith(confirmPassword: event.confirmPassword);
    emit(newState.copyWith(isValid: _isFormValid(newState)));
  }

  void _onSubmitted(
    RegisterFormSubmitted event,
    Emitter<RegisterFormState> emit,
  ) {
    if (state.isValid) {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      authBloc.add(
        AuthRegisterRequested(
          firstName: state.firstName, // Assuming firstName is part of the state
          lastName: state.lastName, // Assuming lastName is part of the state
          phone: state.phone, // Assuming phone is part of the state
          email: state.email,
          password: state.password,
        ),
      );
    } else {
      emit(state.copyWith(errorMessage: 'Please check your input.'));
    }
  }

  bool _isFormValid(RegisterFormState state) {
    return state.email.isNotEmpty &&
        state.email.contains('@') &&
        state.password.isNotEmpty &&
        state.password.length >= 6 &&
        state.confirmPassword == state.password;
  }
}
