import 'package:chat_app_user/core/app/my_app.dart';

import 'config/app_config.dart';
import 'config/flavor_config.dart';
import 'config/environments/development.dart';
import 'shared/services/logger/app_logger.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set flavor
  FlavorConfig.appFlavor = Flavor.development;

  // Set environment
  AppConfig.setEnvironment(DevelopmentEnvironment());

  // Initialize logger
  AppLogger.initialize();

  runApp(MyApp());
}
