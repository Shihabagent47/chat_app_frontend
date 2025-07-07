import '../../shared/services/logger/log_level.dart';
import '../app_config.dart';

class DevelopmentEnvironment extends AppEnvironment {
  @override
  String get appName => 'MyMessenger Dev';

  @override
  String get baseUrl => 'http://192.168.1.103:3000';

  @override
  String get socketUrl => 'wss://dev-socket.mymessenger.com';

  @override
  String get apiKey => 'dev_api_key_here';

  @override
  bool get enableLogging => true;

  @override
  LogLevel get logLevel => LogLevel.debug;

  @override
  bool get enableCrashlytics => false;

  @override
  bool get enableAnalytics => false;

  @override
  String get bundleId => 'com.mymessenger.dev';

  @override
  int get connectTimeout => 30000; // 30 seconds

  @override
  int get receiveTimeout => 30000; // 30 seconds

  @override
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Api-Key': apiKey,
  };
}
