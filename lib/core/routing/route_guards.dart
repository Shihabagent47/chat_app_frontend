import 'package:chat_app_user/core/routing/route_names.dart';
import 'package:chat_app_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGuard {
  static String? checkAuth(BuildContext context, GoRouterState state) {
    // Get auth state from BLoC
    final authBloc = context.read<AuthBloc>();
    final isAuthenticated = authBloc.state is AuthSuccess;

    final protectedRoutes = [
      RouteNames().dashboard,
      RouteNames.userProfile,
      RouteNames.userList,
      RouteNames.settings,
    ];

    if (!isAuthenticated && protectedRoutes.contains(state.location)) {
      return RouteNames.login;
    }

    // If authenticated and trying to access login/register, redirect to dashboard
    if (isAuthenticated &&
        [RouteNames.login, RouteNames.register].contains(state.location)) {
      return RouteNames.dashboard;
    }

    return null; // Allow access
  }
}
