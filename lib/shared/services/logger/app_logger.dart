import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:chat_app_user/shared/services/logger/formatters/console_formatter.dart';
import 'package:chat_app_user/shared/services/logger/log_level.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'formatters/console_formatter.dart';
import 'formatters/file_formatter.dart';
import 'formatters/network_formatter.dart';
import 'outputs/console_output.dart' as console_output;
import 'outputs/file_output.dart' as file_output;
import 'outputs/network_output.dart';
import 'outputs/multi_output.dart' as multi_output;

class AppLogger {
  static Logger? _logger;
  static LogLevel _currentLogLevel = LogLevel.info;

  static void initialize() {
    _currentLogLevel = _getLogLevelFromEnvironment();

    _logger = Logger(
      filter: _AppLogFilter(),
      printer: _getLogPrinter(),
      output: _getLogOutput(),
      level: _mapToLoggerLevel(_currentLogLevel),
    );

    info('Logger initialized for ${FlavorConfig.name} environment');
  }

  static LogLevel _getLogLevelFromEnvironment() {
    if (FlavorConfig.isDevelopment) return LogLevel.debug;
    if (FlavorConfig.isStaging) return LogLevel.info;
    return LogLevel.warning; // Production
  }

  static Level _mapToLoggerLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return Level.debug;
      case LogLevel.info:
        return Level.info;
      case LogLevel.warning:
        return Level.warning;
      case LogLevel.error:
        return Level.error;
      case LogLevel.fatal:
        return Level.fatal;
    }
  }

  static LogPrinter _getLogPrinter() {
    if (FlavorConfig.isDevelopment) {
      return ConsoleFormatter();
    } else if (FlavorConfig.isStaging) {
      return FileFormatter();
    } else {
      return NetworkFormatter();
    }
  }

  static LogOutput _getLogOutput() {
    if (FlavorConfig.isDevelopment) {
      return multi_output.MultiOutput([
        console_output.ConsoleOutput(),
        file_output.FileOutput(),
      ]);
    } else if (FlavorConfig.isStaging) {
      return multi_output.MultiOutput([
        console_output.ConsoleOutput(),
        file_output.FileOutput(),
        NetworkOutput(),
      ]);
    } else {
      return multi_output.MultiOutput([
        file_output.FileOutput(),
        NetworkOutput(),
      ]);
    }
  }

  // Basic logging methods
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger?.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.e(message, error: error, stackTrace: stackTrace);
  }

  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.f(message, error: error, stackTrace: stackTrace);
  }

  // Feature-specific logging methods
  static void logApiRequest(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (FlavorConfig.isDevelopment || FlavorConfig.isStaging) {
      debug('🌐 API Request: $method $url', {'headers': headers, 'body': body});
    }
  }

  static void logApiResponse(
    String url,
    int statusCode, {
    dynamic response,
    Duration? duration,
  }) {
    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    final durationStr =
        duration != null ? ' (${duration.inMilliseconds}ms)' : '';

    if (statusCode >= 400) {
      error('$emoji API Response: $url [$statusCode]$durationStr', response);
    } else if (FlavorConfig.isDevelopment || FlavorConfig.isStaging) {
      debug('$emoji API Response: $url [$statusCode]$durationStr', response);
    }
  }

  static void logSocketEvent(
    String event, {
    dynamic data,
    bool isIncoming = true,
  }) {
    final direction = isIncoming ? '📥' : '📤';
    if (FlavorConfig.isDevelopment) {
      debug('$direction Socket: $event', data);
    }
  }

  static void logUserAction(
    String action, {
    Map<String, dynamic>? params,
    String? userId,
  }) {
    info('👤 User Action: $action', {
      'user_id': userId,
      'params': params,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void logNavigationEvent(
    String from,
    String to, {
    Map<String, dynamic>? params,
  }) {
    debug('🧭 Navigation: $from → $to', params);
  }

  static void logPerformance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? metrics,
  }) {
    final emoji = duration.inMilliseconds > 1000 ? '🐌' : '⚡';
    info(
      '$emoji Performance: $operation (${duration.inMilliseconds}ms)',
      metrics,
    );
  }

  static void logBlocEvent(String blocName, String event, {dynamic data}) {
    debug('🔄 BLoC Event: $blocName.$event', data);
  }

  static void logBlocState(String blocName, String state, {dynamic data}) {
    debug('📊 BLoC State: $blocName → $state', data);
  }

  static void logDatabaseOperation(
    String operation,
    String table, {
    dynamic data,
    Duration? duration,
  }) {
    final durationStr =
        duration != null ? ' (${duration.inMilliseconds}ms)' : '';
    debug('🗃️ DB: $operation on $table$durationStr', data);
  }

  // Utility methods
  static void logException(
    Exception exception,
    StackTrace stackTrace, {
    String? context,
  }) {
    error(
      'Exception${context != null ? ' in $context' : ''}: ${exception.toString()}',
      exception,
      stackTrace,
    );
  }

  static void logFlutterError(FlutterErrorDetails details) {
    fatal(
      'Flutter Error: ${details.exception}',
      details.exception,
      details.stack,
    );
  }

  static void dispose() {
    _logger?.close();
    _logger = null;
  }
}

class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return AppConfig.environment.enableLogging;
  }
}

// Extension for easy logging in any class
extension LoggerExtension on Object {
  void logDebug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.debug('[$runtimeType] $message', error, stackTrace);
  }

  void logInfo(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.info('[$runtimeType] $message', error, stackTrace);
  }

  void logWarning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.warning('[$runtimeType] $message', error, stackTrace);
  }

  void logError(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.error('[$runtimeType] $message', error, stackTrace);
  }
}
