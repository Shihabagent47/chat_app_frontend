import 'package:sqflite/sqflite.dart';
import '../../../../core/offline/database/local_data_base.dart';
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
  final DatabaseService databaseService;

  ChatLocalDataSourceImpl({required this.databaseService});

  Future<Database> get _database => databaseService.database;

  @override
  Future<List<MessageModel>> getMessages(String chatRoomId) async {
    final db = await _database;
    final maps = await db.query(
      'messages',
      where: 'chatRoomId = ?',
      whereArgs: [chatRoomId],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => MessageModel.fromJson(map)).toList();
  }

  @override
  Future<void> insertMessage(MessageModel message) async {
    final db = await _database;
    await db.insert(
      'messages',
      message.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateMessage(MessageModel message) async {
    final db = await _database;
    await db.update(
      'messages',
      message.toJson(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    final db = await _database;
    await db.delete('messages', where: 'id = ?', whereArgs: [messageId]);
  }

  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    final db = await _database;
    final maps = await db.query('chat_rooms', orderBy: 'lastActivity DESC');

    return maps.map((map) => ChatRoomModel.fromJson(map)).toList();
  }

  @override
  Future<void> insertChatRoom(ChatRoomModel chatRoom) async {
    final db = await _database;
    await db.insert(
      'chat_rooms',
      chatRoom.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateChatRoom(ChatRoomModel chatRoom) async {
    final db = await _database;
    await db.update(
      'chat_rooms',
      chatRoom.toJson(),
      where: 'id = ?',
      whereArgs: [chatRoom.id],
    );
  }

  @override
  Future<void> insertMediaMessage(MediaMessageModel mediaMessage) async {
    final db = await _database;
    await db.insert(
      'media_messages',
      mediaMessage.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<MediaMessageModel?> getMediaMessage(String messageId) async {
    final db = await _database;
    final maps = await db.query(
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
