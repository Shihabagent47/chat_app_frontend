import 'package:chat_app_user/core/network/dio_client.dart';
import 'package:dio/dio.dart';

import '../models/user.dart';

// Remote Data Source
abstract class UserRemoteDataSource {
  Future<List<User>> getUsers();
  Future<User> getUserById(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _networkClient;

  UserRemoteDataSourceImpl({required DioClient networkClient})
    : _networkClient = networkClient;

  @override
  Future<List<User>> getUsers() async {
    try {
      final response = await _networkClient.client.get('/users');
      final List<dynamic> usersJson = response.data;
      return usersJson.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch users: ${e.message}');
    }
  }

  @override
  Future<User> getUserById(String id) async {
    try {
      final response = await _networkClient.client.get('/users/$id');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch user: ${e.message}');
    }
  }
}
