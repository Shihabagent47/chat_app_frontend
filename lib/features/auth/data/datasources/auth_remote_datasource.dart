import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/core/network/dio_client.dart';
import 'package:chat_app_user/shared/services/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthResponseModel> refreshToken();

  Future<void> logout();

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient networkClient;
  final SecureStorageService secureStorage;

  AuthRemoteDataSourceImpl({
    required this.networkClient,
    required this.secureStorage,
  });

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await networkClient.client.post(
        '${AppConfig.environment.baseUrl}login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.data);

        // Save tokens to secure storage
        await secureStorage.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresAt: authResponse.expiresAt,
        );

        // Save user data
        await secureStorage.saveUserData(
          jsonEncode((authResponse.user as UserModel).toJson()),
        );

        return authResponse;
      } else {
        throw ServerException('Login failed', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await networkClient.client.post(
        '${AppConfig.environment.baseUrl}register',
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.data);

        // Save tokens to secure storage
        await secureStorage.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresAt: authResponse.expiresAt,
        );

        // Save user data
        await secureStorage.saveUserData(
          jsonEncode((authResponse.user as UserModel).toJson()),
        );

        return authResponse;
      } else {
        throw ServerException(
          'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponseModel> refreshToken() async {
    try {
      final refreshToken = await secureStorage.getRefreshToken();

      if (refreshToken == null) {
        throw ServerException('No refresh token found');
      }

      final response = await networkClient.client.post(
        '${AppConfig.environment.baseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.data);

        // Save new tokens
        await secureStorage.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresAt: authResponse.expiresAt,
        );

        return authResponse;
      } else {
        throw ServerException(
          'Token refresh failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final accessToken = await secureStorage.getAccessToken();

      if (accessToken != null) {
        await networkClient.client.post(
          '${AppConfig.environment.baseUrl}/auth/logout',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
      }
    } on DioException catch (e) {
      // Even if logout fails on server, we should clear local storage
      print('Logout API call failed: ${e.message}');
    } finally {
      // Always clear local storage
      await secureStorage.clearAll();
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final userData = await secureStorage.getUserData();

      if (userData != null) {
        final userJson = jsonDecode(userData);
        return UserModel.fromJson(userJson);
      }

      // If no cached user data, fetch from API
      final accessToken = await secureStorage.getAccessToken();

      if (accessToken == null) {
        throw ServerException('No access token found');
      }

      final response = await networkClient.client.get(
        '${AppConfig.environment.baseUrl}/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);

        // Cache user data
        await secureStorage.saveUserData(jsonEncode(user.toJson()));

        return user;
      } else {
        throw ServerException(
          'Failed to get current user',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      case DioExceptionType.badResponse:
        return ServerException(
          e.response?.data['message'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      default:
        return ServerException('Unexpected error occurred');
    }
  }
}
