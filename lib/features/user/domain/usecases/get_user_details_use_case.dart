import 'package:chat_app_user/features/user/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_repository.dart';

class GetUserDetailsUseCase {
  final UserRepository repository;

  GetUserDetailsUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String userId, {
    bool forceRefresh = false,
  }) {
    return repository.getUserById(userId, forceRefresh: forceRefresh);
  }
}
