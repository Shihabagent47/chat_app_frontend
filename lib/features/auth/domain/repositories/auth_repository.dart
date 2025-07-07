import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_response_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResponseEntity>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResponseEntity>> refreshToken();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, bool>> isAuthenticated();

  Future<Either<Failure, String?>> getAccessToken();
}
