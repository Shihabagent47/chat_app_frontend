import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../../shared/services/storage/secure_storage_service.dart';
import 'api_interceptors.dart';
import 'loggin_interceptor.dart';

class DioClient {
  final Dio _dio;

  DioClient({
    required SecureStorageService storage,
    required AppEnvironment environment,
  }) : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: environment.baseUrl,
      connectTimeout: Duration(seconds: environment.connectTimeout),
      receiveTimeout: Duration(seconds: environment.receiveTimeout),
      contentType: environment.headers['Content-Type'] ?? 'application/json',
    );

    _dio.interceptors.addAll([
      ApiInterceptor(storage: storage),
      DioLoggingInterceptor(),
    ]);
  }

  Dio get client => _dio;
}
