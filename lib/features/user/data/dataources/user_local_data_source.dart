import 'package:chat_app_user/features/user/data/models/user_list_response_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/offline/database/local_data_base.dart';

abstract class UserLocalDataSource {
  Future<UserListResponseModel> getCachedUsers();
  Future<UserModel?> getCachedUserById(String id);
  Future<void> cacheUsers(UserListResponseModel users);
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final DatabaseService _databaseService;

  UserLocalDataSourceImpl({required DatabaseService databaseService})
    : _databaseService = databaseService;

  @override
  Future<void> cacheUser(UserModel user) async {
    final db = await _databaseService.database;

    await db.insert(
      'users',
      {
        'id': user.id,
        'email': user.email,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Upsert behavior
    );
  }

  @override
  Future<void> cacheUsers(UserListResponseModel users) async {
    final db = await _databaseService.database;
    final batch = db.batch();

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (var user in users.data) {
      batch.insert('users', {
        'id': user.id,
        'email': user.email,
        'createdAt': timestamp,
        'updatedAt': timestamp,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  // @override
  // Future<List<UserModel>> getCachedUsers() async {
  //   // final db = await _databaseService.database;
  //   // final result = await db.query('users');
  //   //
  //   // return result
  //   //     .map(
  //   //       (json) => UserModel(
  //   //         id: json['id'] as String,
  //   //         name: json['name'] as String,
  //   //         email: json['email'] as String,
  //   //       ),
  //   //     )
  //   //     .toList();
  // }

  // @override
  // Future<UserModel?> getCachedUserById(String id) async {
  //   final db = await _databaseService.database;
  //   final result = await db.query(
  //     'users',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //     limit: 1,
  //   );
  //
  //   if (result.isNotEmpty) {
  //     final json = result.first;
  //     return UserModel(
  //       id: json['id'] as String,
  //       name: json['name'] as String,
  //       email: json['email'] as String,
  //     );
  //   }
  //
  //   return null;
  // }

  @override
  Future<void> clearCache() async {
    final db = await _databaseService.database;
    await db.delete('users');
  }

  @override
  Future<UserModel?> getCachedUserById(String id) {
    // TODO: implement getCachedUserById
    throw UnimplementedError();
  }

  @override
  Future<UserListResponseModel> getCachedUsers() {
    // TODO: implement getCachedUsers
    throw UnimplementedError();
  }
}
