import 'package:chat_app_user/features/user/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/user_repository.dart';
import '../dataources/user_local_data_source.dart';
import '../dataources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, UserListResponseEntity>> getUsers({
    bool forceRefresh = false,
  }) async {
    try {
      // if (!forceRefresh) {
      //   final cachedUsers = await _localDataSource.getCachedUsers();
      //   // if (cachedUsers.isNotEmpty) {
      //   //   return cachedUsers;
      //   // }
      // }

      final users = await _remoteDataSource.getUsers();
      //await _localDataSource.cacheUsers(users.data);
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(
    String id, {
    bool forceRefresh = false,
  }) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, UserEntity>> getUserById(
  //   String id, {
  //   bool forceRefresh = false,
  // }) async {
  //   try {
  //     if (!forceRefresh) {
  //       final cachedUser = await _localDataSource.getCachedUserById(id);
  //       // if (cachedUser != null) {
  //       //   return cachedUser;
  //       // }
  //     }
  //
  //     final user = await _remoteDataSource.getUserById(id);
  //     await _localDataSource.cacheUser(user);
  //     return Right(user);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   } on NetworkException catch (e) {
  //     return Left(NetworkFailure(e.message));
  //   } catch (e) {
  //     return Left(ServerFailure('Unexpected error occurred'));
  //   }
  // }
}
