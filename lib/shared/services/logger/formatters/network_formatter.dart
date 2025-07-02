import 'dart:convert';
import 'package:logger/logger.dart';

class NetworkFormatter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final payload = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'level': event.level.name,
      'message': event.message.toString(),
      'deviceInfo': {
        'platform': 'flutter',
        // Add device-specific info here
      },
      if (event.error != null) 'error': event.error.toString(),
      if (event.stackTrace != null) 'stackTrace': event.stackTrace.toString(),
    };

    return [jsonEncode(payload)];
  }
}
