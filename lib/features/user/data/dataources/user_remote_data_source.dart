import 'package:chat_app_user/core/network/dio_client.dart';
import 'package:chat_app_user/features/user/data/models/user_list_response_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/model/api_response.dart';
import '../../../../core/model/paginated_list_response.dart';
import '../../../../core/repositories/base_repository.dart';
import '../models/query_params.dart';

// Remote Data Source
abstract class UserRemoteDataSource {
  Future<PaginatedListResponse<UserModel>> getUsers(UserQueryParams queryParams,);
  Future<ApiResponse<UserModel>> getUserById(String id);
}

class UserRemoteDataSourceImpl extends BaseRepository implements UserRemoteDataSource {
  UserRemoteDataSourceImpl({required super.dioClient});


  @override
  Future<PaginatedListResponse<UserModel>> getUsers(UserQueryParams queryParams,) async {
    try {
      final response = await dioClient.client.get('/users');
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
      final response = await dioClient.client.get('/users/$id');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch user: ${e.message}');
    }
  }
}
