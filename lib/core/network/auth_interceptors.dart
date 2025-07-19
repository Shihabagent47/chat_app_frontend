import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../shared/services/storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor({required SecureStorageService storage, required Dio dio})
    : _storage = storage,
      _dio = dio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add access token to requests if available
    final accessToken = await _storage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      final refreshResult = await _handleTokenRefresh();

      if (refreshResult) {
        // Retry the original request with new token
        try {
          final response = await _retryRequest(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          handler.next(err);
          return;
        }
      } else {
        // Refresh failed, clear tokens and let the error propagate
        await _clearTokens();
        handler.next(err);
        return;
      }
    }

    handler.next(err);
  }

  Future<bool> _handleTokenRefresh() async {
    // Prevent multiple simultaneous refresh attempts
    if (_isRefreshing) {
      // Wait for ongoing refresh to complete
      await _waitForRefreshCompletion();
      return await _storage.getAccessToken() != null;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _storage.getRefreshToken();

      // Check if refresh token exists and is valid
      if (refreshToken == null) {
        debugPrint('No refresh token available');
        return false;
      }

      // Attempt to refresh the token
      final response = await _dio.post(
        '/auth/refresh', // Adjust endpoint as needed
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Save new tokens
        await _storage.setAccessToken(data['access_token']);
        await _storage.setRefreshToken(data['refresh_token']);

        debugPrint('Token refreshed successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    // Add the new access token to the retry request
    final newAccessToken = await _storage.getAccessToken();
    if (newAccessToken != null) {
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
    }

    return await _dio.fetch(requestOptions);
  }

  Future<void> _waitForRefreshCompletion() async {
    // Simple polling mechanism to wait for refresh completion
    while (_isRefreshing) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _clearTokens() async {
    await _storage.deleteAccessToken();
    await _storage.deleteRefreshToken();
  }
}
