import 'package:dio/dio.dart';
import 'package:chat_app_user/shared/services/logger/app_logger.dart';

class DioLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.logApiRequest(
      options.method,
      options.uri.toString(),
      headers: options.headers,
      body: options.data,
    );
    options.extra['start_time'] = DateTime.now(); // for duration
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime?;
    final duration =
        startTime != null ? DateTime.now().difference(startTime) : null;

    AppLogger.logApiResponse(
      response.requestOptions.uri.toString(),
      response.statusCode ?? 0,
      response: response.data,
      duration: duration,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['start_time'] as DateTime?;
    final duration =
        startTime != null ? DateTime.now().difference(startTime) : null;

    AppLogger.logApiResponse(
      err.requestOptions.uri.toString(),
      err.response?.statusCode ?? 0,
      response: err.response?.data ?? err.message,
      duration: duration,
    );

    AppLogger.logException(
      err,
      err.stackTrace ?? StackTrace.current,
      context: 'DioError',
    );

    handler.next(err);
  }
}
