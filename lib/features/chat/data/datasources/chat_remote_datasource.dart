import 'dart:async';
import 'package:chat_app_user/core/network/socket_io_client.dart';
import 'package:dio/dio.dart';
import '../../../../core/model/paginated_list_response.dart';
import '../../../../core/repositories/base_repository.dart';
import '../models/chat_message_qury_params.dart';
import '../models/chat_query_params.dart';
import '../models/message_model.dart';
import '../models/chat_room_model.dart';
import '../models/media_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<PaginatedListResponse<MessageModel>> getMessages(
    String chatRoomId,
    ChatMessageQueryParams params,
  );
  Future<MessageModel> sendMessage(MessageModel message);
  Future<void> deleteMessage(String messageId);
  Future<void> markAsRead(String chatRoomId, String messageId);
  Future<PaginatedListResponse<ChatRoomModel>> getChatRooms(
    ChatQueryParams params,
  );
  Future<MediaMessageModel> uploadMedia(String filePath, String messageId);
  Stream<MessageModel> watchMessages(String chatRoomId);
  Stream<List<String>> watchTypingUsers(String chatRoomId);
  Future<void> updateTypingStatus(String chatRoomId, bool isTyping);
}

class ChatRemoteDataSourceImpl extends BaseRepository
    implements ChatRemoteDataSource {
  final IoClient ioClient;

  ChatRemoteDataSourceImpl({required this.ioClient, required super.dioClient});

  @override
  Future<PaginatedListResponse<MessageModel>> getMessages(
    String chatRoomId,
    ChatMessageQueryParams params,
  ) async {
    return getPaginatedList(
      '/conversations/$chatRoomId/messages',
      MessageModel.fromJson,
      queryParams: params,
    );
  }

  @override
  Future<MessageModel> sendMessage(MessageModel message) async {
    final response = await dioClient.client.post(
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
    final response = await dioClient.client.delete('/messages/$messageId');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }

  @override
  Future<void> markAsRead(String chatRoomId, String messageId) async {
    final response = await dioClient.client.put(
      '/messages/$messageId/read',
      data: {'chatRoomId': chatRoomId},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark message as read');
    }
  }

  @override
  Future<PaginatedListResponse<ChatRoomModel>> getChatRooms(
    ChatQueryParams params,
  ) async {
    return await getPaginatedList(
      '/conversations',
      ChatRoomModel.fromJson,
      queryParams: params,
    );
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

    final response = await dioClient.client.post(
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

    ioClient.socket.emit('join_conversation', {'conversationId': chatRoomId});

    void onNewMessage(dynamic data) {
      if (!controller.isClosed) controller.add(MessageModel.fromJson(data));
    }

    void onMessageUpdated(dynamic data) {
      if (!controller.isClosed) controller.add(MessageModel.fromJson(data));
    }

    ioClient.socket.on('new_message', onNewMessage);
    ioClient.socket.on('message_updated', onMessageUpdated);

    controller.onCancel = () {
      ioClient.socket.off('new_message', onNewMessage);
      ioClient.socket.off('message_updated', onMessageUpdated);
      ioClient.socket.emit('leave_conversation', {'conversationId': chatRoomId});
    };

    return controller.stream;
  }

  @override
  Stream<List<String>> watchTypingUsers(String chatRoomId) {
    final controller = StreamController<List<String>>.broadcast();
    final typingUsers = <String>{};

    void onTyping(dynamic data) {
      final userId = data['userId'] as String?;
      if (userId == null || controller.isClosed) return;
      typingUsers.add(userId);
      controller.add(typingUsers.toList());
    }

    void onStopTyping(dynamic data) {
      final userId = data['userId'] as String?;
      if (userId == null || controller.isClosed) return;
      typingUsers.remove(userId);
      controller.add(typingUsers.toList());
    }

    ioClient.socket.on('user_typing', onTyping);
    ioClient.socket.on('user_stop_typing', onStopTyping);

    controller.onCancel = () {
      ioClient.socket.off('user_typing', onTyping);
      ioClient.socket.off('user_stop_typing', onStopTyping);
    };

    return controller.stream;
  }

  @override
  Future<void> updateTypingStatus(String chatRoomId, bool isTyping) async {
    ioClient.socket.emit(
      isTyping ? 'typing' : 'stop_typing',
      {'conversationId': chatRoomId},
    );
  }
}