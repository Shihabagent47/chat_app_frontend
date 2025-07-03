import 'package:chat_app_user/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_config.dart';
import '../routing/app_router.dart';
import '../../injection_container.dart' as di;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

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
            title: config.appName,
            debugShowCheckedModeBanner: config.environment.isDevelopment,
            theme: _getTheme(themeState),
            routerConfig: AppRouter.getRouter(config),
            builder: (context, child) {
              return _AppWrapper(config: config, child: child!);
            },
          );
        },
      ),
    );
  }

  ThemeData _getTheme(ThemeState state) {
    // Return theme based on state and environment
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

class _AppWrapper extends StatelessWidget {
  final AppConfig config;
  final Widget child;

  const _AppWrapper({required this.config, required this.child});

  @override
  Widget build(BuildContext context) {
    Widget app = child;

    // Add environment banner for non-production
    if (!config.environment.isProduction) {
      app = Banner(
        message: config.environment.name.toUpperCase(),
        location: BannerLocation.topStart,
        color: config.environment.isDevelopment ? Colors.red : Colors.orange,
        child: app,
      );
    }

    return app;
  }
}
