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
  String get bundleId;

  bool get enableLogging;
  LogLevel get logLevel;

  bool get enableCrashlytics;
  bool get enableAnalytics;

  int get connectTimeout; // in milliseconds
  int get receiveTimeout; // in milliseconds

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Api-Key': apiKey,
  };
}
