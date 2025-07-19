import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static const String _databaseName = 'chat_app.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create messages table
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        chatRoomId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        senderName TEXT,
        content TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'text',
        timestamp INTEGER NOT NULL,
        isRead INTEGER NOT NULL DEFAULT 0,
        messageStatus TEXT DEFAULT 'sent',
        replyToMessageId TEXT,
        editedAt INTEGER,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        FOREIGN KEY (chatRoomId) REFERENCES chat_rooms (id) ON DELETE CASCADE
      )
    ''');

    // Create chat_rooms table
    await db.execute('''
      CREATE TABLE chat_rooms (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'private',
        description TEXT,
        avatarUrl TEXT,
        participantIds TEXT NOT NULL,
        lastMessageId TEXT,
        lastActivity INTEGER NOT NULL,
        unreadCount INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    // Create media_messages table
    await db.execute('''
      CREATE TABLE media_messages (
        id TEXT PRIMARY KEY,
        messageId TEXT NOT NULL UNIQUE,
        fileName TEXT NOT NULL,
        fileSize INTEGER NOT NULL,
        mimeType TEXT NOT NULL,
        fileUrl TEXT NOT NULL,
        localPath TEXT,
        thumbnailUrl TEXT,
        uploadStatus TEXT DEFAULT 'pending',
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        FOREIGN KEY (messageId) REFERENCES messages (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better query performance
    await db.execute(
      'CREATE INDEX idx_messages_chatroom_timestamp ON messages (chatRoomId, timestamp DESC)',
    );
    await db.execute('CREATE INDEX idx_messages_sender ON messages (senderId)');
    await db.execute(
      'CREATE INDEX idx_chatrooms_activity ON chat_rooms (lastActivity DESC)',
    );
    await db.execute(
      'CREATE INDEX idx_media_messages_message ON media_messages (messageId)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Example migration for version 2
      // await db.execute('ALTER TABLE messages ADD COLUMN newColumn TEXT');
    }
  }

  // Utility methods for common operations
  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('media_messages');
      await txn.delete('messages');
      await txn.delete('chat_rooms');
    });
  }

  Future<void> clearChatRoomData(String chatRoomId) async {
    final db = await database;
    await db.transaction((txn) async {
      // Delete media messages first (foreign key constraint)
      await txn.rawDelete(
        '''
        DELETE FROM media_messages 
        WHERE messageId IN (
          SELECT id FROM messages WHERE chatRoomId = ?
        )
      ''',
        [chatRoomId],
      );

      // Delete messages
      await txn.delete(
        'messages',
        where: 'chatRoomId = ?',
        whereArgs: [chatRoomId],
      );

      // Delete chat room
      await txn.delete('chat_rooms', where: 'id = ?', whereArgs: [chatRoomId]);
    });
  }

  Future<int> getUnreadMessagesCount(String chatRoomId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM messages WHERE chatRoomId = ? AND isRead = 0',
      [chatRoomId],
    );
    return result.first['count'] as int;
  }

  Future<Map<String, dynamic>?> getLastMessage(String chatRoomId) async {
    final db = await database;
    final result = await db.query(
      'messages',
      where: 'chatRoomId = ?',
      whereArgs: [chatRoomId],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> markAllMessagesAsRead(String chatRoomId) async {
    final db = await database;
    await db.update(
      'messages',
      {'isRead': 1},
      where: 'chatRoomId = ? AND isRead = 0',
      whereArgs: [chatRoomId],
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
