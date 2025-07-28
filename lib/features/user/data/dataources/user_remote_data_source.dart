import 'package:chat_app_user/core/network/dio_client.dart';
import 'package:chat_app_user/features/user/data/models/user_list_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/model/api_response.dart';
import '../../../../core/model/paginated_list_response.dart';
import '../../../../core/repositories/base_repository.dart';
import '../models/query_params.dart';

// Remote Data Source
abstract class UserRemoteDataSource {
  Future<PaginatedListResponse<UserModel>> fetchUsers(UserQueryParams params);
  Future<UserModel> fetchUserById(String id);
}

class UserRemoteDataSourceImpl extends BaseRepository
    implements UserRemoteDataSource {
  UserRemoteDataSourceImpl({required super.dioClient});

  @override
  Future<PaginatedListResponse<UserModel>> fetchUsers(
    UserQueryParams params,
  ) async {
    return await getPaginatedList<UserModel>(
      '/users', // Replace with your actual endpoint
      UserModel.fromJson,
      queryParams: params,
    );
  }

  @override
  Future<UserModel> fetchUserById(String id) async {
    final response = await getSingle<UserModel>(
      '/users/$id', // Replace with your actual endpoint
      UserModel.fromJson,
    );
    return response.data!;
  }
}
