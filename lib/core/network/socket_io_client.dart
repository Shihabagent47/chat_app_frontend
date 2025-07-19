import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../config/app_config.dart';
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
             // .setTimeout(environment.socketTimeout ?? 10000)
             // .setExtraHeaders(environment.socketHeaders ?? {})
             .build(),
       ) {
    _setupSocketListeners(storage);
  }

  void _setupSocketListeners(SecureStorageService storage) {
    _socket.onConnect((_) {
      print('Socket connected');
      _authenticateSocket(storage);
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket.onConnectError((error) {
      print('Socket connection error: $error');
    });

    _socket.onError((error) {
      print('Socket error: $error');
    });

    _socket.onReconnect((_) {
      print('Socket reconnected');
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
      print('Socket authentication error: $e');
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
}
