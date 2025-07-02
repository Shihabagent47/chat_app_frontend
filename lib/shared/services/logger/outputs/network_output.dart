import 'dart:convert';
import 'package:chat_app_user/config/app_config.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class NetworkOutput extends LogOutput {
  final Dio _dio = Dio();
  final List<Map<String, dynamic>> _logBuffer = [];
  final int _bufferSize = 50;
  bool _isUploading = false;

  @override
  Future<void> init() async{
    super.init();

    // Configure Dio for log uploads
    _dio.options.baseUrl = AppConfig.environment.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  @override
  void output(OutputEvent event) {
    // Only send error and fatal logs to server
    if (event.level.index >= Level.error.index) {
      try {
        final logData = jsonDecode(event.lines.first) as Map<String, dynamic>;
        _logBuffer.add(logData);

        if (_logBuffer.length >= _bufferSize) {
          _uploadLogs();
        }
      } catch (e) {
        print('Failed to parse log for network output: $e');
      }
    }
  }

  Future<void> _uploadLogs() async {
    if (_isUploading || _logBuffer.isEmpty) return;

    _isUploading = true;

    try {
      final logsToUpload = List<Map<String, dynamic>>.from(_logBuffer);
      _logBuffer.clear();

      await _dio.post(
        '/api/logs',
        data: {
          'logs': logsToUpload,
          'app_version': '1.0.0', // Get from package info
          'device_info': await _getDeviceInfo(),
        },
      );
    } catch (e) {
      // If upload fails, add logs back to buffer
      _logBuffer.addAll(_logBuffer);
      print('Failed to upload logs: $e');
    } finally {
      _isUploading = false;
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    // Implement device info collection
    return {'platform': 'flutter', 'flavor': AppConfig.environment.appName};
  }

  @override
  Future<void> destroy() async{
    if (_logBuffer.isNotEmpty) {
      _uploadLogs();
    }
    super.destroy();
  }
}
