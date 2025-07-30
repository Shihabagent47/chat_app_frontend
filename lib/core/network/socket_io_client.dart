import 'package:chat_app_user/shared/services/logger/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../config/app_config.dart';
import '../../config/flavor_config.dart';
import '../../shared/services/storage/secure_storage_service.dart';

class IoClient {
  final IO.Socket _socket;

  IoClient({
    required SecureStorageService storage,
    required AppEnvironment environment,
  }) : _socket = IO.io(
         environment.socketUrl,
         IO.OptionBuilder()
             .setTransports(['websocket'])
             .enableAutoConnect()
             .enableReconnection()
             .setReconnectionAttempts(5)
             .setReconnectionDelay(2000)
             .setTimeout(10000)
             .setExtraHeaders({})
             .build(),
       ) {
    _setupSocketListeners(storage);
  }

  void _setupSocketListeners(SecureStorageService storage) {
    _socket.onConnect((_) {
      logSocketEvent('connect');
      _authenticateSocket(storage);
    });

    _socket.onDisconnect((_) {
      logSocketEvent('disconnect');
    });

    _socket.onConnectError((error) {
      logSocketError(error.toString());
    });

    _socket.onError((error) {
      logSocketError(error.toString());
    });

    _socket.onReconnect((_) {
      logSocketEvent('reconnect');
      _authenticateSocket(storage);
    });
  }

  Future<void> _authenticateSocket(SecureStorageService storage) async {
    try {
      final token = await storage.getAccessToken();
      if (token != null) {
        _socket.emit('authenticate', {'token': token});
      }
    } catch (e) {
      logSocketError('Failed to authenticate socket: $e');
    }
  }

  IO.Socket get socket => _socket;

  void connect() {
    if (!_socket.connected) {
      _socket.connect();
    }
  }

  void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
    }
  }

  void dispose() {
    _socket.dispose();
  }

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
