import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../../shared/services/storage/secure_storage_service.dart';
import 'api_interceptors.dart';
import 'loggin_interceptor.dart';

class DioClient {
  final Dio _dio;

  DioClient({required SecureStorageService storage}) : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.environment.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    );

    _dio.interceptors.addAll([
      ApiInterceptor(storage: storage),
      DioLoggingInterceptor(),
    ]);
  }

  Dio get client => _dio;
}
