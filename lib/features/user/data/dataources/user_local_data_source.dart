import 'package:sqflite/sqflite.dart';

import '../../../../core/offline/database/local_data_base.dart';
import '../models/user.dart';

abstract class UserLocalDataSource {
  Future<List<User>> getCachedUsers();
  Future<User?> getCachedUserById(String id);
  Future<void> cacheUsers(List<User> users);
  Future<void> cacheUser(User user);
  Future<void> clearCache();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final DatabaseService _databaseService;

  UserLocalDataSourceImpl({required DatabaseService databaseService})
    : _databaseService = databaseService;

  @override
  Future<void> cacheUser(User user) async {
    final db = await _databaseService.database;

    await db.insert(
      'users',
      {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Upsert behavior
    );
  }

  @override
  Future<void> cacheUsers(List<User> users) async {
    final db = await _databaseService.database;
    final batch = db.batch();

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (var user in users) {
      batch.insert('users', {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'createdAt': timestamp,
        'updatedAt': timestamp,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<User>> getCachedUsers() async {
    final db = await _databaseService.database;
    final result = await db.query('users');

    return result
        .map(
          (json) => User(
            id: json['id'] as String,
            name: json['name'] as String,
            email: json['email'] as String,
            phone: '',
            username: '',
            website: '',
          ),
        )
        .toList();
  }

  @override
  Future<User?> getCachedUserById(String id) async {
    final db = await _databaseService.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final json = result.first;
      return User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: '',
        username: '',
        website: '',
      );
    }

    return null;
  }

  @override
  Future<void> clearCache() async {
    final db = await _databaseService.database;
    await db.delete('users');
  }
}
