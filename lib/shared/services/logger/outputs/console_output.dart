import 'dart:developer' as developer;
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:logger/logger.dart';

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final lines = event.lines;

    if (FlavorConfig.isDevelopment) {
      for (final line in lines) {
        // Enhanced print with timestamp and level for terminal
        print(line);

        // Use developer.log for structured logging
        developer.log(
          line,
          name: 'MyMessenger',
          level: _mapLogLevel(event.level),
        );
      }
    } else {
      // Use print for other environments
      for (final line in lines) {
        print(line);
      }
    }
  }

  int _mapLogLevel(Level level) {
    switch (level) {
      case Level.trace:
        return 500;
      case Level.debug:
        return 700;
      case Level.info:
        return 800;
      case Level.warning:
        return 900;
      case Level.error:
        return 1000;
      case Level.fatal:
        return 1200;
      default:
        return 800;
    }
  }
}
