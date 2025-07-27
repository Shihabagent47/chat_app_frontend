import 'dart:async';
import 'dart:convert';
import 'package:chat_app_user/core/network/dio_client.dart';
import 'package:chat_app_user/core/network/socket_io_client.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../config/app_config.dart';
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
  final DioClient networkClient;
  final IoClient ioClient;

  ChatRemoteDataSourceImpl({
    required this.networkClient,
    required this.ioClient,
  });

  @override
  Future<List<MessageModel>> getMessages(String chatRoomId) async {
    final response = await networkClient.client.get(
      '${AppConfig.environment.baseUrl}/conversations/$chatRoomId/messages',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data']['data'];
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Future<MessageModel> sendMessage(MessageModel message) async {
    final response = await networkClient.client.post(
      '/conversations/${message.chatRoomId}/messages',
      data: message.toJson(),
    );

    if (response.statusCode == 201) {
      return MessageModel.fromJson(response.data);
    } else {
      throw Exception('Failed to send message');
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    final response = await networkClient.client.delete('/messages/$messageId');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }

  @override
  Future<void> markAsRead(String chatRoomId, String messageId) async {
    final response = await networkClient.client.put(
      '/messages/$messageId/read',
      data: {'chatRoomId': chatRoomId},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark message as read');
    }
  }

  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    final response = await networkClient.client.get('/conversations');

    final rawData = response.data;
    if (response.statusCode == 200 &&
        rawData['data'] != null &&
        rawData['data']['data'] is List) {
      final List<dynamic> data = rawData['data']['data'];
      return data.map((json) => ChatRoomModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chat rooms: Invalid format or status');
    }
  }

  @override
  Future<MediaMessageModel> uploadMedia(
    String filePath,
    String messageId,
  ) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'messageId': messageId,
    });

    final response = await networkClient.client.post(
      '/media/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      return MediaMessageModel.fromJson(response.data);
    } else {
      throw Exception('Failed to upload media');
    }
  }

  @override
  Stream<MessageModel> watchMessages(String chatRoomId) {
    final controller = StreamController<MessageModel>.broadcast();

    ioClient.socket.on('message_$chatRoomId', (data) {
      controller.add(MessageModel.fromJson(data));
    });

    return controller.stream;
  }

  @override
  Stream<List<String>> watchTypingUsers(String chatRoomId) {
    final controller = StreamController<List<String>>.broadcast();

    ioClient.socket.on('typing_$chatRoomId', (data) {
      controller.add(List<String>.from(data));
    });

    return controller.stream;
  }

  @override
  Future<void> updateTypingStatus(String chatRoomId, bool isTyping) async {
    ioClient.socket.emit('typing_status', {
      'chatRoomId': chatRoomId,
      'isTyping': isTyping,
    });
  }
}
