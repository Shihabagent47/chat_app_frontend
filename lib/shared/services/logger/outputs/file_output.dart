import 'dart:io';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileOutput extends LogOutput {
  File? _logFile;
  IOSink? _logSink;
  final int _maxFileSize = 5 * 1024 * 1024; // 5MB
  final int _maxFiles = 5;
  Timer? _flushTimer;

  @override
  Future<void> init() async{
    super.init();
    _initLogFile();

    // Flush logs every 30 seconds
    _flushTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _flushLogs();
    });
  }

  @override
  Future<void> destroy() async{
    _flushTimer?.cancel();
    _logSink?.close();
    super.destroy();
  }

  Future<void> _initLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      await _cleanupOldLogs(logDir);

      final fileName =
          'app_${DateTime.now().toIso8601String().split('T')[0]}.log';
      _logFile = File('${logDir.path}/$fileName');

      // Open file for appending
      _logSink = _logFile!.openWrite(mode: FileMode.append);
    } catch (e) {
      print('Failed to initialize log file: $e');
    }
  }

  Future<void> _cleanupOldLogs(Directory logDir) async {
    try {
      final files =
          await logDir
              .list()
              .where((entity) => entity is File)
              .cast<File>()
              .toList();

      if (files.length > _maxFiles) {
        // Sort by last modified date
        files.sort(
          (a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()),
        );

        // Delete oldest files
        for (int i = 0; i < files.length - _maxFiles; i++) {
          await files[i].delete();
        }
      }
    } catch (e) {
      print('Failed to cleanup old logs: $e');
    }
  }

  @override
  void output(OutputEvent event) {
    if (_logSink != null) {
      try {
        for (final line in event.lines) {
          _logSink!.writeln(line);
        }

        // Check file size and rotate if necessary
        _checkFileRotation();
      } catch (e) {
        print('Failed to write to log file: $e');
      }
    }
  }

  Future<void> _checkFileRotation() async {
    if (_logFile != null) {
      try {
        final fileSize = await _logFile!.length();

        if (fileSize > _maxFileSize) {
          await _rotateLogFile();
        }
      } catch (e) {
        print('Failed to check file rotation: $e');
      }
    }
  }

  Future<void> _rotateLogFile() async {
    try {
      await _logSink?.close();

      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      // Rename current file with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final rotatedFile = File('${logDir.path}/app_rotated_$timestamp.log');
      await _logFile!.rename(rotatedFile.path);

      // Create new log file
      await _initLogFile();
    } catch (e) {
      print('Failed to rotate log file: $e');
    }
  }

  void _flushLogs() {
    _logSink?.flush();
  }
}
