import 'package:chat_app_user/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/model/paginated_list_response.dart';
import '../../../../core/usecases/usecase.dart';

import '../../data/models/query_params.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase
    implements UseCase<PaginatedListResponse<UserEntity>, UserQueryParams> {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedListResponse<UserEntity>>> call(
    UserQueryParams params,
  ) {
    return repository.getUsers(params);
  }
}
