import 'package:chat_app_user/core/error/failures.dart';

import 'package:chat_app_user/features/user/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/model/paginated_list_response.dart';
import '../../data/models/query_params.dart';

abstract class UserRepository {
  Future<Either<Failure, PaginatedListResponse<UserEntity>>> getUsers(
    UserQueryParams queryParams,
  );
  Future<Either<Failure, UserEntity>> getUserById(
    String id, {
    bool forceRefresh = false,
  });
}
