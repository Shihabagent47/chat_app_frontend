import 'package:dartz/dartz.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/entities/media_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_model.dart';
import '../models/chat_room_model.dart';
import '../models/media_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Exception, List<ChatRoom>>> getChatRooms() async {
    try {
      final remoteChatRooms = await remoteDataSource.getChatRooms();
      // for (final chatRoom in remoteChatRooms) {
      //   await localDataSource.insertChatRoom(chatRoom);
      // }
      return Right(remoteChatRooms);
    } catch (e) {
      try {
        final localChatRooms = await localDataSource.getChatRooms();
        return Right(localChatRooms);
      } catch (e) {
        return Left(Exception('Failed to get chat rooms: $e'));
      }
    }
  }

  @override
  Future<Either<Exception, List<Message>>> getMessages(
    String chatRoomId,
  ) async {
    try {
      final remoteMessages = await remoteDataSource.getMessages(chatRoomId);
      // for (final message in remoteMessages) {
      //   await localDataSource.insertMessage(message);
      // }
      return Right(remoteMessages);
    } catch (e) {
      try {
        final localMessages = await localDataSource.getMessages(chatRoomId);
        return Right(localMessages);
      } catch (e) {
        return Left(Exception('Failed to get messages: $e'));
      }
    }
  }

  @override
  Future<Either<Exception, Message>> sendMessage(Message message) async {
    try {
      final messageModel = MessageModel.fromEntity(message);
      //  await localDataSource.insertMessage(messageModel);

      final sentMessage = await remoteDataSource.sendMessage(messageModel);
      //   await localDataSource.updateMessage(sentMessage);

      return Right(sentMessage);
    } catch (e) {
      return Left(Exception('Failed to send message: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteMessage(String messageId) async {
    try {
      await remoteDataSource.deleteMessage(messageId);
      await localDataSource.deleteMessage(messageId);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to delete message: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> markAsRead(
    String chatRoomId,
    String messageId,
  ) async {
    try {
      await remoteDataSource.markAsRead(chatRoomId, messageId);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to mark as read: $e'));
    }
  }

  @override
  Future<Either<Exception, MediaMessage>> uploadMedia(
    String filePath,
    String messageId,
  ) async {
    try {
      final mediaMessage = await remoteDataSource.uploadMedia(
        filePath,
        messageId,
      );
      await localDataSource.insertMediaMessage(mediaMessage);
      return Right(mediaMessage);
    } catch (e) {
      return Left(Exception('Failed to upload media: $e'));
    }
  }

  @override
  Stream<List<Message>> watchMessages(String chatRoomId) {
    return remoteDataSource
        .watchMessages(chatRoomId)
        .map((message) => [message]);
  }

  @override
  Stream<List<String>> watchTypingUsers(String chatRoomId) {
    return remoteDataSource.watchTypingUsers(chatRoomId);
  }

  @override
  Future<Either<Exception, void>> updateTypingStatus(
    String chatRoomId,
    bool isTyping,
  ) async {
    try {
      await remoteDataSource.updateTypingStatus(chatRoomId, isTyping);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to update typing status: $e'));
    }
  }
}
