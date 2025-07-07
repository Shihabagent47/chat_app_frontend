import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_config.dart';
import '../../config/flavor_config.dart';
import '../../shared/services/logger/app_logger.dart';

class NavigationHelper {
  static void goToLogin(BuildContext context) {
    _logNavigation('login');
    context.goNamed('login');
  }

  static void goToRegister(BuildContext context) {
    _logNavigation('register');
    context.pushNamed('register');
  }

  static void goToHome(BuildContext context) {
    _logNavigation('home');
    context.goNamed('home');
  }

  static void goToUserProfile(BuildContext context) {
    _logNavigation('userProfile');
    context.goNamed('userProfile');
  }

  static void goToUserDetail(BuildContext context, String userId) {
    _logNavigation('userDetail', params: {'id': userId});
    context.goNamed('userDetail', pathParameters: {'id': userId});
  }

  static void goToSettings(BuildContext context) {
    _logNavigation('settings');
    context.goNamed('settings');
  }

  // Development-only navigation
  static void goToDebug(BuildContext context) {
    if (FlavorConfig.isDevelopment) {
      _logNavigation('debug');
      context.goNamed('debug');
    }
  }

  static void goToDevTools(BuildContext context) {
    if (FlavorConfig.isDevelopment) {
      _logNavigation('devTools');
      context.goNamed('devTools');
    }
  }

  // Staging-only navigation
  static void goToStagingInfo(BuildContext context) {
    if (FlavorConfig.isStaging) {
      _logNavigation('stagingInfo');
      context.goNamed('stagingInfo');
    }
  }

  static void goBack(BuildContext context) {
    _logNavigation('back');
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('home');
    }
  }

  static void _logNavigation(String route, {Map<String, dynamic>? params}) {
    final environment = AppConfig.environment;
    if (environment.enableLogging) {
      AppLogger.info(
        '🧭 NavigationHelper: $route ${params != null ? 'with params: $params' : ''}',
      );
    }
  }
}
