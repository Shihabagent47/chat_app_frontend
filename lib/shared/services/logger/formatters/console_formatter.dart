import 'package:chat_app_user/config/flavor_config.dart';
import 'package:logger/logger.dart';

class ConsoleFormatter extends LogPrinter {
  static final levelEmojis = {
    Level.trace: '🔍',
    Level.debug: '🐛',
    Level.info: 'ℹ️',
    Level.warning: '⚠️',
    Level.error: '❌',
    Level.fatal: '💀',
  };

  static final levelColors = {
    Level.trace: AnsiColor.fg(8),
    Level.debug: AnsiColor.fg(12),
    Level.info: AnsiColor.fg(10),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.fatal: AnsiColor.fg(199),
  };

  @override
  List<String> log(LogEvent event) {
    final color = levelColors[event.level];
    final emoji = levelEmojis[event.level];
    final message = event.message;
    final time = DateTime.now();
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}.'
        '${time.millisecond.toString().padLeft(3, '0')}';

    final lines = <String>[];

    if (FlavorConfig.isDevelopment) {
      // Development: Detailed formatting
      final header =
          color?.call(
            '$emoji [${event.level.name.toUpperCase()}] [$timeStr] [${FlavorConfig.name.toUpperCase()}]',
          ) ??
              '$emoji [${event.level.name.toUpperCase()}] [$timeStr] [${FlavorConfig.name.toUpperCase()}]';

      lines.add(header);
      lines.add(color?.call('Message: $message') ?? 'Message: $message');

      if (event.error != null) {
        lines.add(
          color?.call('Error: ${event.error}') ?? 'Error: ${event.error}',
        );
      }

      if (event.stackTrace != null && event.level.index >= Level.error.index) {
        lines.add(color?.call('StackTrace:') ?? 'StackTrace:');
        final stackLines = event.stackTrace.toString().split('\n');
        for (int i = 0; i < stackLines.length && i < 10; i++) {
          lines.add(color?.call('  ${stackLines[i]}') ?? '  ${stackLines[i]}');
        }
      }
    } else {
      // Production: Compact formatting
      final logLine =
          '$emoji [$timeStr] [${event.level.name.toUpperCase()}] $message';
      lines.add(logLine);

      if (event.error != null) {
        lines.add('Error: ${event.error}');
      }
    }

    return lines;
  }
}
