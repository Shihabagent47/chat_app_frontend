import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:chat_app_user/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app_user/features/auth/presentation/pages/register_page.dart';
import 'package:chat_app_user/features/chat/presentation/pages/chat_list_page.dart';
import 'package:chat_app_user/shared/page/debug_page.dart';
import 'package:chat_app_user/shared/page/error_page.dart';
import 'package:go_router/go_router.dart';
import '../../../features/chat/presentation/pages/chaat_room_page.dart';
import '../../../features/user/presentation/pages/user_details_page.dart';
import '../../../features/user/presentation/pages/user_list_page.dart';
import '../shell_wrapper.dart';
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
    List<RouteBase> routes = [
      ShellRoute(
        builder: (context, state, child) {
          return ShellWrapper(child: child);
        },
        routes: [
          // Chat List Route
          GoRoute(
            path: RouteNames.chatList,
            name: RouteNames.chatList,
            builder: (context, state) => ChatListPage(),
            routes: [
              // Chat Room Route
              GoRoute(
                path: RouteNames.chatRoom,
                name: RouteNames.chatRoom,
                builder:
                    (context, state) =>
                        ChatRoomPage(chatRoomId: state.pathParameters['id']!),
              ),
            ],
          ),

          //Users Route
          GoRoute(
            path: RouteNames.userList,
            name: RouteNames.userList,
            builder: (context, state) => UserListPage(),
            routes: [
              GoRoute(
                path: RouteNames.userDetail,
                name: RouteNames.userDetail,
                builder:
                    (context, state) =>
                        UserDetailsPage(userId: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      ),

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
