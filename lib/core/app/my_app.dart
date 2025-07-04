import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../routing/app_router.dart';
import '../../injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_config.dart';
import '../../config/flavor_config.dart';
import '../routing/app_router.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final environment = AppConfig.environment;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<UserBloc>()),
        BlocProvider(create: (_) => di.sl<ThemeBloc>()),
        // Add other BLoCs here
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: environment.appName,
            debugShowCheckedModeBanner: environment.enableLogging,
            theme: _getTheme(themeState),
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return _AppWrapper(child: child!);
            },
          );
        },
      ),
    );
  }

  ThemeData _getTheme(ThemeState state) {
    // Customize theme based on flavor
    final primaryColor =
        FlavorConfig.isDevelopment
            ? Colors.red
            : FlavorConfig.isStaging
            ? Colors.orange
            : Colors.blue;

    return ThemeData(
      primarySwatch: primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _AppWrapper extends StatelessWidget {
  final Widget child;

  const _AppWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    Widget app = child;

    // Add environment banner for non-production
    if (!FlavorConfig.isProduction) {
      final bannerMessage =
          FlavorConfig.isDevelopment
              ? 'DEV'
              : FlavorConfig.isStaging
              ? 'STAGING'
              : 'UNKNOWN';

      final bannerColor =
          FlavorConfig.isDevelopment
              ? Colors.red
              : FlavorConfig.isStaging
              ? Colors.orange
              : Colors.grey;

      app = Banner(
        message: bannerMessage,
        location: BannerLocation.topStart,
        color: bannerColor,
        child: app,
      );
    }

    return app;
  }
}
