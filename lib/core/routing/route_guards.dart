import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:chat_app_user/core/routing/route_names.dart';
import 'package:chat_app_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_state.dart';

class AuthGuard {
  static String? checkAuth(BuildContext context, GoRouterState state) {
    final environment = AppConfig.environment;

    // Log navigation in development
    if (environment.enableLogging) {
      print('🧭 Navigation: ');
    }

    // Get auth state from BLoC
    final authBloc = context.read<AuthBloc>();
    final isAuthenticated = authBloc.state.status == AuthStatus.authenticated;
    final protectedRoutes = [
      RouteNames.dashboard,
      RouteNames.userProfile,
      RouteNames.userList,
      RouteNames.settings,
    ];

    // Add development routes to protected routes
    if (FlavorConfig.isDevelopment) {
      protectedRoutes.addAll(['/debug', '/dev-tools']);
    }

    // Add staging routes to protected routes
    if (FlavorConfig.isStaging) {
      protectedRoutes.addAll(['/staging-info']);
    }

    if (!isAuthenticated) {
      if (environment.enableLogging) {
        print('🚫 Access denied to - redirecting to login');
      }
      return RouteNames.login;
    }

    // If authenticated and trying to access login/register, redirect to dashboard
    if (isAuthenticated) {
      if (environment.enableLogging) {
        print('✅ Already authenticated - redirecting to dashboard');
      }
      return RouteNames.dashboard;
    }

    return null; // Allow access
  }

  static bool _isProtectedRoute(String location, List<String> protectedRoutes) {
    return protectedRoutes.any((route) => location.startsWith(route));
  }
}
