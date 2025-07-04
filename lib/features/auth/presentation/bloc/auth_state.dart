import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
    this.message,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(UserEntity user)
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated({String? message})
    : this._(status: AuthStatus.unauthenticated, message: message);

  final AuthStatus status;
  final UserEntity? user;
  final String? message;

  @override
  List<Object?> get props => [status, user, message];
}
