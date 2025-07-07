import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [firstName, lastName, phone, email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthTokenRefreshRequested extends AuthEvent {}

class AuthUserRequested extends AuthEvent {}
