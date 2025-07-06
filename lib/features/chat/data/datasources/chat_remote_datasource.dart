import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message_model.dart';
import '../models/chat_room_model.dart';
import '../models/media_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<MessageModel>> getMessages(String chatRoomId);
  Future<MessageModel> sendMessage(MessageModel message);
  Future<void> deleteMessage(String messageId);
  Future<void> markAsRead(String chatRoomId, String messageId);
  Future<List<ChatRoomModel>> getChatRooms();
  Future<MediaMessageModel> uploadMedia(String filePath, String messageId);
  Stream<MessageModel> watchMessages(String chatRoomId);
  Stream<List<String>> watchTypingUsers(String chatRoomId);
  Future<void> updateTypingStatus(String chatRoomId, bool isTyping);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client httpClient;
  final IO.Socket socket;
  final String baseUrl;

  ChatRemoteDataSourceImpl({
    required this.httpClient,
    required this.socket,
    required this.baseUrl,
  });

  @override
  Future<List<MessageModel>> getMessages(String chatRoomId) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/messages/$chatRoomId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Future<MessageModel> sendMessage(MessageModel message) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/messages'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(message.toJson()),
    );

    if (response.statusCode == 201) {
      return MessageModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send message');
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/messages/$messageId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }

  @override
  Future<void> markAsRead(String chatRoomId, String messageId) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/messages/$messageId/read'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'chatRoomId': chatRoomId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark message as read');
    }
  }

  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/chat-rooms'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ChatRoomModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chat rooms');
    }
  }

  @override
  Future<MediaMessageModel> uploadMedia(
    String filePath,
    String messageId,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/media/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.fields['messageId'] = messageId;

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return MediaMessageModel.fromJson(json.decode(responseBody));
    } else {
      throw Exception('Failed to upload media');
    }
  }

  @override
  Stream<MessageModel> watchMessages(String chatRoomId) {
    final controller = StreamController<MessageModel>.broadcast();

    socket.on('message_$chatRoomId', (data) {
      controller.add(MessageModel.fromJson(data));
    });

    return controller.stream;
  }

  @override
  Stream<List<String>> watchTypingUsers(String chatRoomId) {
    final controller = StreamController<List<String>>.broadcast();

    socket.on('typing_$chatRoomId', (data) {
      controller.add(List<String>.from(data));
    });

    return controller.stream;
  }

  @override
  Future<void> updateTypingStatus(String chatRoomId, bool isTyping) async {
    socket.emit('typing_status', {
      'chatRoomId': chatRoomId,
      'isTyping': isTyping,
    });
  }
}
