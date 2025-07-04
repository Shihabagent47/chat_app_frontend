import '../../shared/services/logger/log_level.dart';
import '../app_config.dart';

class StagingEnvironment extends AppEnvironment {
  @override
  String get appName => 'MyMessenger Staging';

  @override
  String get baseUrl => 'https://staging-api.mymessenger.com';

  @override
  String get socketUrl => 'wss://staging-socket.mymessenger.com';

  @override
  String get apiKey => 'staging_api_key_here';

  @override
  bool get enableLogging => true;

  @override
  LogLevel get logLevel => LogLevel.info;

  @override
  bool get enableCrashlytics => true;

  @override
  bool get enableAnalytics => true;

  @override
  String get bundleId => 'com.mymessenger.staging';

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
