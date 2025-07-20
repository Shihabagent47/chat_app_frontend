import 'package:chat_app_user/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase implements UseCase<UserListResponseEntity, NoParams> {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  @override
  Future<Either<Failure, UserListResponseEntity>> call(NoParams params) {
    bool forceRefresh = false;
    return repository.getUsers(forceRefresh: forceRefresh);
  }
}
