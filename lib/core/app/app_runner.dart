import 'dart:ui';

import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../injection_container.dart' as di;
import '../bloc/app_bloc_observer.dart';
import 'my_app.dart';
import 'package:chat_app_user/shared/services/logger/app_logger.dart';

class AppRunner {
  static Future<void> run(AppEnvironment environment, Flavor flavor) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Set environment and flavor
    AppConfig.setEnvironment(environment);
    FlavorConfig.appFlavor = flavor;

    // Initialize dependency injection
    await di.init(environment);

    // Initialize logger
    AppLogger.initialize();

    // Setup system UI
    await _setupSystemUI();

    // Setup error handling
    _setupErrorHandling();

    // Setup bloc observer for debugging
    if (environment.enableLogging) {
      Bloc.observer = AppBlocObserver();
    }
    // Run the app
    runApp(MyApp());
  }

  static Future<void> _setupSystemUI() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static void _setupErrorHandling() {
    final environment = AppConfig.environment;

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);

      if (environment.enableLogging) {
        print('🚨 Flutter Error: ${details.exception}');
        print('Stack trace: ${details.stack}');
      }

      if (environment.enableCrashlytics) {
        // Send to crashlytics
        // FirebaseCrashlytics.instance.recordFlutterError(details);
      }
    };

    // Handle errors outside of Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      if (environment.enableLogging) {
        print('🚨 Platform Error: $error');
        print('Stack trace: $stack');
      }

      if (environment.enableCrashlytics) {
        // Send to crashlytics
        // FirebaseCrashlytics.instance.recordError(error, stack);
      }

      return true;
    };
  }
}
