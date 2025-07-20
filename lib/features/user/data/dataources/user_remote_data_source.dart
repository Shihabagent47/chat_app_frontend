import 'package:chat_app_user/core/network/dio_client.dart';
import 'package:chat_app_user/features/user/data/models/user_list_response_model.dart';
import 'package:dio/dio.dart';

// Remote Data Source
abstract class UserRemoteDataSource {
  Future<UserListResponseModel> getUsers();
  Future<UserModel> getUserById(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _networkClient;

  UserRemoteDataSourceImpl({required DioClient networkClient})
    : _networkClient = networkClient;

  @override
  Future<UserListResponseModel> getUsers() async {
    try {
      final response = await _networkClient.client.get('/users');
      final userListResponseModel = UserListResponseModel.fromJson(
        response.data,
      );
      return userListResponseModel;
    } on DioException catch (e) {
      throw Exception('Failed to fetch users: ${e.message}');
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final response = await _networkClient.client.get('/users/$id');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch user: ${e.message}');
    }
  }
}
