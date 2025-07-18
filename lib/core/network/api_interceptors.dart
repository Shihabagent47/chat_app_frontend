import 'package:dio/dio.dart';

import '../../shared/services/storage/secure_storage_service.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService storage;

  ApiInterceptor({required this.storage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Global error transformation
    handler.next(err);
  }
}
