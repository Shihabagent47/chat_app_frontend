import 'package:sqflite/sqflite.dart';
import '../models/message_model.dart';
import '../models/chat_room_model.dart';
import '../models/media_message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getMessages(String chatRoomId);
  Future<void> insertMessage(MessageModel message);
  Future<void> updateMessage(MessageModel message);
  Future<void> deleteMessage(String messageId);
  Future<List<ChatRoomModel>> getChatRooms();
  Future<void> insertChatRoom(ChatRoomModel chatRoom);
  Future<void> updateChatRoom(ChatRoomModel chatRoom);
  Future<void> insertMediaMessage(MediaMessageModel mediaMessage);
  Future<MediaMessageModel?> getMediaMessage(String messageId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Database database;

  ChatLocalDataSourceImpl(this.database);

  @override
  Future<List<MessageModel>> getMessages(String chatRoomId) async {
    final maps = await database.query(
      'messages',
      where: 'chatRoomId = ?',
      whereArgs: [chatRoomId],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => MessageModel.fromJson(map)).toList();
  }

  @override
  Future<void> insertMessage(MessageModel message) async {
    await database.insert(
      'messages',
      message.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateMessage(MessageModel message) async {
    await database.update(
      'messages',
      message.toJson(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await database.delete('messages', where: 'id = ?', whereArgs: [messageId]);
  }

  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    final maps = await database.query(
      'chat_rooms',
      orderBy: 'lastActivity DESC',
    );

    return maps.map((map) => ChatRoomModel.fromJson(map)).toList();
  }

  @override
  Future<void> insertChatRoom(ChatRoomModel chatRoom) async {
    await database.insert(
      'chat_rooms',
      chatRoom.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateChatRoom(ChatRoomModel chatRoom) async {
    await database.update(
      'chat_rooms',
      chatRoom.toJson(),
      where: 'id = ?',
      whereArgs: [chatRoom.id],
    );
  }

  @override
  Future<void> insertMediaMessage(MediaMessageModel mediaMessage) async {
    await database.insert(
      'media_messages',
      mediaMessage.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<MediaMessageModel?> getMediaMessage(String messageId) async {
    final maps = await database.query(
      'media_messages',
      where: 'messageId = ?',
      whereArgs: [messageId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return MediaMessageModel.fromJson(maps.first);
    }
    return null;
  }
}
