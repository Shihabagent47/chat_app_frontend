import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:chat_app_user/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app_user/features/auth/presentation/pages/register_page.dart';
import 'package:chat_app_user/shared/page/debug_page.dart';
import 'package:chat_app_user/shared/page/error_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'route_names.dart';
import 'route_guards.dart';

class AppRouter {
  static GoRouter? _router;

  static GoRouter get router {
    _router ??= _createRouter();
    return _router!;
  }

  static GoRouter _createRouter() {
    final environment = AppConfig.environment;

    return GoRouter(
      initialLocation: RouteNames.home,
      debugLogDiagnostics: environment.enableLogging,
      redirect: AuthGuard.checkAuth,
      errorBuilder:
          (context, state) => ErrorPage(
            error: state.error,
            showDebugInfo: environment.enableLogging,
          ),
      routes: _buildRoutes(),
    );
  }

  static List<RouteBase> _buildRoutes() {
    final environment = AppConfig.environment;

    List<RouteBase> routes = [
      // Home Route

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => RegisterPage(),
      ),
    ];

    // Add development-only routes
    if (FlavorConfig.isDevelopment) {
      routes.addAll(_getDevelopmentRoutes());
    }

    // Add staging-specific routes
    if (FlavorConfig.isStaging) {
      routes.addAll(_getStagingRoutes());
    }

    return routes;
  }

  static List<RouteBase> _getDevelopmentRoutes() {
    return [
      GoRoute(
        path: '/debug',
        name: 'debug',
        builder: (context, state) => const DebugPage(),
      ),
    ];
  }

  static List<RouteBase> _getStagingRoutes() {
    return [];
  }
}
