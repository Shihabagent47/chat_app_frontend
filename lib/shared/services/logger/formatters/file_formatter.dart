import 'dart:convert';
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:logger/logger.dart';

class FileFormatter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final time = DateTime.now().toIso8601String();
    final level = event.level.name.toUpperCase();
    final flavor = FlavorConfig.name.toUpperCase();

    final logData = {
      'timestamp': time,
      'level': level,
      'flavor': flavor,
      'message': event.message.toString(),
      if (event.error != null) 'error': event.error.toString(),
      if (event.stackTrace != null) 'stackTrace': event.stackTrace.toString(),
    };

    // JSON format for structured logging
    final jsonLog = jsonEncode(logData);
    return [jsonLog];
  }
}
