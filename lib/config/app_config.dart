import '../shared/services/logger/log_level.dart';

abstract class AppConfig {
  static late AppEnvironment _environment;

  static AppEnvironment get environment => _environment;

  static void setEnvironment(AppEnvironment environment) {
    _environment = environment;
  }
}

abstract class AppEnvironment {
  String get appName;
  String get baseUrl;
  String get socketUrl;
  String get apiKey;
  bool get enableLogging;
  LogLevel get logLevel;
  bool get enableCrashlytics;
  bool get enableAnalytics;
  String get bundleId;
}
