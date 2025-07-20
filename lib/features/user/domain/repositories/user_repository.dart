import 'package:chat_app_user/core/error/failures.dart';

import 'package:chat_app_user/features/user/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, UserListResponseEntity>> getUsers({
    bool forceRefresh = false,
  });
  Future<Either<Failure, UserEntity>> getUserById(
    String id, {
    bool forceRefresh = false,
  });
}
