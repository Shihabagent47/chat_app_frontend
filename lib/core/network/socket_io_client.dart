import 'package:chat_app_user/shared/services/logger/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../config/app_config.dart';
import '../../config/flavor_config.dart';
import '../../shared/services/storage/secure_storage_service.dart';

class IoClient {
  late final IO.Socket _socket;
  final SecureStorageService _storage;

  IoClient({
    required SecureStorageService storage,
    required AppEnvironment environment,
  }) : _storage = storage {
    _socket = IO.io(
      '${environment.socketUrl}/chat',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .setTimeout(10000)
          .build(),
    );
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socket.onConnect((_) => logSocketEvent('connect'));
    _socket.onDisconnect((_) => logSocketEvent('disconnect'));
    _socket.onConnectError((error) => logSocketError(error.toString()));
    _socket.onError((error) => logSocketError(error.toString()));
    _socket.onReconnect((_) async {
      logSocketEvent('reconnect');
      await _applyAuth();
    });
  }

  Future<void> _applyAuth() async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      _socket.auth = {'token': 'Bearer $token'};
    }
  }

  /// Call once after login (or on app start if already authenticated).
  Future<void> initialize() async {
    await _applyAuth();
    _socket.connect();
  }

  IO.Socket get socket => _socket;

  Future<void> connect() async {
    if (!_socket.connected) {
      await initialize();
    }
  }

  void disconnect() {
    if (_socket.connected) _socket.disconnect();
  }

  void dispose() => _socket.dispose();

  static void logSocketEvent(
    String event, {
    dynamic data,
    bool isIncoming = true,
  }) {
    final direction = isIncoming ? '📥' : '📤';
    if (FlavorConfig.isDevelopment) {
      AppLogger.info('$direction Socket: $event', data);
    }
  }

  static void logSocketError(String error) {
    AppLogger.error('Socket error: $error');
  }
}