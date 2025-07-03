import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_config.dart';
import '../../injection_container.dart' as di;
import 'my_app.dart';

class AppRunner {
  static Future<void> run(AppConfig config) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize app configuration
    AppConfig.initialize(config);

    // Initialize dependency injection
    await di.init(config);

    // Setup system UI
    await _setupSystemUI();

    // Setup error handling
    _setupErrorHandling();

    // Setup bloc observer for debugging
    if (config.enableLogging) {
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
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (AppConfig.instance.enableCrashlytics) {
        // Send to crashlytics
        // FirebaseCrashlytics.instance.recordFlutterError(details);
      }
    };
  }
}

// BLoC Observer for debugging
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (AppConfig.instance.enableLogging) {
      print('🔥 BLoC Created: ${bloc.runtimeType}');
    }
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (AppConfig.instance.enableLogging) {
      print('🔄 BLoC Transition: ${bloc.runtimeType}');
      print('Current State: ${transition.currentState}');
      print('Event: ${transition.event}');
      print('Next State: ${transition.nextState}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('❌ BLoC Error: ${bloc.runtimeType}');
    print('Error: $error');
    if (AppConfig.instance.enableCrashlytics) {
      // Send to crashlytics
    }
  }
}
