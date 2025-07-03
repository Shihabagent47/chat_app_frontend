import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/user/presentation/pages/user_profile_page.dart';
import '../features/user/presentation/pages/user_list_page.dart';
import '../features/user/presentation/pages/user_detail_page.dart';
import 'route_names.dart';
import 'route_guards.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    debugLogDiagnostics: true,
    redirect: AuthGuard.checkAuth,
    refreshListenable: GoRouterRefreshStream([
      // Listen to auth changes to trigger route refresh
      // You can add your auth stream here
    ]),
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    routes: [
      // Home Route
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Dashboard Route
      GoRoute(
        path: RouteNames.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),

      // User Routes - Nested routing
      GoRoute(
        path: '/user',
        name: 'user',
        builder: (context, state) => const UserMainPage(),
        routes: [
          GoRoute(
            path: '/profile',
            name: 'userProfile',
            builder: (context, state) => const UserProfilePage(),
          ),
          GoRoute(
            path: '/list',
            name: 'userList',
            builder: (context, state) => const UserListPage(),
          ),
          GoRoute(
            path: '/:id',
            name: 'userDetail',
            builder: (context, state) {
              final userId = state.pathParameters['id']!;
              return UserDetailPage(userId: userId);
            },
          ),
        ],
      ),

      // Settings Route
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}

// Navigation Helper Class
class NavigationHelper {
  static void goToLogin(BuildContext context) {
    context.goNamed('login');
  }

  static void goToDashboard(BuildContext context) {
    context.goNamed('dashboard');
  }

  static void goToUserProfile(BuildContext context) {
    context.goNamed('userProfile');
  }

  static void goToUserDetail(BuildContext context, String userId) {
    context.goNamed('userDetail', pathParameters: {'id': userId});
  }

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('home');
    }
  }
}
