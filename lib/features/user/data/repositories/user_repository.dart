import '../dataources/user_local_data_source.dart';
import '../dataources/user_remote_data_source.dart';
import '../models/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers({bool forceRefresh = false});
  Future<User> getUserById(String id, {bool forceRefresh = false});
  Future<List<User>> searchUsers(String query);
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<List<User>> getUsers({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cachedUsers = await _localDataSource.getCachedUsers();
        if (cachedUsers.isNotEmpty) {
          return cachedUsers;
        }
      }

      final users = await _remoteDataSource.getUsers();
      await _localDataSource.cacheUsers(users);
      return users;
    } catch (e) {
      // Fallback to cached data if remote fails
      final cachedUsers = await _localDataSource.getCachedUsers();
      if (cachedUsers.isNotEmpty) {
        return cachedUsers;
      }
      rethrow;
    }
  }

  @override
  Future<User> getUserById(String id, {bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cachedUser = await _localDataSource.getCachedUserById(id);
        if (cachedUser != null) {
          return cachedUser;
        }
      }

      final user = await _remoteDataSource.getUserById(id);
      await _localDataSource.cacheUser(user);
      return user;
    } catch (e) {
      // Fallback to cached data if remote fails
      final cachedUser = await _localDataSource.getCachedUserById(id);
      if (cachedUser != null) {
        return cachedUser;
      }
      rethrow;
    }
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    final users = await getUsers();
    if (query.isEmpty) return users;

    return users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase()) ||
          user.username.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
