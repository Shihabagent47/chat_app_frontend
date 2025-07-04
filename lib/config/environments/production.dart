import '../../shared/services/logger/log_level.dart';
import '../app_config.dart';

class ProductionEnvironment extends AppEnvironment {
  @override
  String get appName => 'MyMessenger';

  @override
  String get baseUrl => 'https://api.mymessenger.com';

  @override
  String get socketUrl => 'wss://socket.mymessenger.com';

  @override
  String get apiKey => 'prod_api_key_here';

  @override
  bool get enableLogging => false;

  @override
  LogLevel get logLevel => LogLevel.error;

  @override
  bool get enableCrashlytics => true;

  @override
  bool get enableAnalytics => true;

  @override
  String get bundleId => 'com.mymessenger';

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
