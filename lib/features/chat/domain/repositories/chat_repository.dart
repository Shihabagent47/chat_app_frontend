import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../entities/chat_room.dart';
import '../entities/media_message.dart';

abstract class ChatRepository {
  Future<Either<Exception, List<ChatRoom>>> getChatRooms();
  Future<Either<Exception, List<Message>>> getMessages(String chatRoomId);
  Future<Either<Exception, Message>> sendMessage(Message message);
  Future<Either<Exception, void>> deleteMessage(String messageId);
  Future<Either<Exception, void>> markAsRead(
    String chatRoomId,
    String messageId,
  );
  Future<Either<Exception, MediaMessage>> uploadMedia(
    String filePath,
    String messageId,
  );
  Stream<List<Message>> watchMessages(String chatRoomId);
  Stream<List<String>> watchTypingUsers(String chatRoomId);
  Future<Either<Exception, void>> updateTypingStatus(
    String chatRoomId,
    bool isTyping,
  );
}
