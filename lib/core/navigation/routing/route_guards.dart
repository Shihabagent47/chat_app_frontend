import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:chat_app_user/core/navigation/routing/route_names.dart';
import 'package:chat_app_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../shared/services/logger/app_logger.dart';

class AuthGuard {
  static String? checkAuth(BuildContext context, GoRouterState state) {
    final environment = AppConfig.environment;

    // Log navigation in development
    if (environment.enableLogging) {
      AppLogger.logNavigationEvent(
        state.fullPath ?? 'unknown',
        'Checking access',
      );
    }

    // Get auth state from BLoC
    final authBloc = context.read<AuthBloc>();
    final isAuthenticated = authBloc.state.status == AuthStatus.authenticated;
    final protectedRoutes = [
      RouteNames.dashboard,
      RouteNames.home,
      RouteNames.chatList,
      RouteNames.chatRoom,
      RouteNames.userProfile,
      RouteNames.userList,
      RouteNames.settings,
    ];
    final publicRoutes = [
      RouteNames.login,
      RouteNames.register,
      '/forgot-password',
      RouteNames.authCheck,
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
      final isPublic = publicRoutes.any(
        (route) => state.uri.toString().startsWith(route),
      );
      if (isPublic) {
        return null;
      }

      AppLogger.warning(
        'Access denied to ${state.uri.toString()} – redirecting to login',
      );
      return RouteNames.login;
    }
    // If authenticated and trying to access login/register, redirect to dashboard
    if (isAuthenticated && publicRoutes.contains(state.uri.toString())) {
      AppLogger.info('Already authenticated – redirecting to dashboard');
      return RouteNames.chatList;
    }

    return null; // Allow access
  }

  static bool _isProtectedRoute(String location, List<String> protectedRoutes) {
    return protectedRoutes.any((route) => location.startsWith(route));
  }
}
