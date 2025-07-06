import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/call_session_model.dart';

abstract class CallSignalingDataSource {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendSignal(String event, Map<String, dynamic> data);
  Stream<Map<String, dynamic>> onSignal(String event);
  Future<CallSessionModel> initiateCall(String receiverId, String callType);
  Future<void> answerCall(String callId, bool accept);
  Future<void> endCall(String callId);
}

class CallSignalingDataSourceImpl implements CallSignalingDataSource {
  late IO.Socket _socket;
  final String serverUrl;
  final String userId;

  CallSignalingDataSourceImpl({required this.serverUrl, required this.userId});

  @override
  Future<void> connect() async {
    _socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.on('connect', (_) {
      print('Connected to signaling server');
      _socket.emit('join', {'userId': userId});
    });

    _socket.on('disconnect', (_) {
      print('Disconnected from signaling server');
    });
  }

  @override
  Future<void> disconnect() async {
    _socket.disconnect();
  }

  @override
  Future<void> sendSignal(String event, Map<String, dynamic> data) async {
    _socket.emit(event, data);
  }

  @override
  Stream<Map<String, dynamic>> onSignal(String event) {
    return _socket.on(event).map((data) => Map<String, dynamic>.from(data));
  }

  @override
  Future<CallSessionModel> initiateCall(
    String receiverId,
    String callType,
  ) async {
    final callData = {
      'receiverId': receiverId,
      'callType': callType,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _socket.emit('initiate_call', callData);

    // Wait for call response
    final completer = Completer<CallSessionModel>();

    _socket.on('call_initiated', (data) {
      final callSession = CallSessionModel.fromJson(data);
      completer.complete(callSession);
    });

    return completer.future;
  }

  @override
  Future<void> answerCall(String callId, bool accept) async {
    _socket.emit('answer_call', {'callId': callId, 'accept': accept});
  }

  @override
  Future<void> endCall(String callId) async {
    _socket.emit('end_call', {'callId': callId});
  }
}
