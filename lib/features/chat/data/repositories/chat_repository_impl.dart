import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/model/paginated_list_response.dart';
import '../../../../core/model/pagination_meta.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/entities/media_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_query_params.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource _localDataSource;
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({
    required ChatLocalDataSource localDataSource,
    required ChatRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, PaginatedListResponse<ChatRoom>>> getChatRooms(
    ChatQueryParams params,
  ) async {
    try {
      final remoteChatRooms = await _remoteDataSource.getChatRooms(params);
      // for (final chatRoom in remoteChatRooms) {
      //   await _localDataSource.insertChatRoom(chatRoom);
      // }
      return Right(remoteChatRooms);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      try {
        final localChatRooms = await _localDataSource.getChatRooms();
        // Convert List<ChatRoomModel> to PaginatedListResponse<ChatRoom>
        final paginatedResponse = PaginatedListResponse<ChatRoom>(
          success: true,
          data: localChatRooms.cast<ChatRoom>(),
          message: 'Chat rooms retrieved from cache',
          errors: [],
          meta: PaginationMeta(
            page: 1,
            limit: localChatRooms.length,
            total: localChatRooms.length,
            pages: 1,
          ),
        );
        return Right(paginatedResponse);
      } on CacheException catch (cacheError) {
        return Left(NetworkFailure(e.message));
      } catch (cacheError) {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error occurred while getting chat rooms'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatRoomId) async {
    try {
      final remoteMessages = await _remoteDataSource.getMessages(chatRoomId);
      // for (final message in remoteMessages) {
      //   await _localDataSource.insertMessage(message);
      // }
      return Right(remoteMessages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      try {
        final localMessages = await _localDataSource.getMessages(chatRoomId);
        return Right(localMessages);
      } on CacheException catch (cacheError) {
        return Left(NetworkFailure(e.message));
      } catch (cacheError) {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error occurred while getting messages'),
      );
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(Message message) async {
    try {
      final messageModel = MessageModel.fromEntity(message);
      //  await _localDataSource.insertMessage(messageModel);

      final sentMessage = await _remoteDataSource.sendMessage(messageModel);
      //   await _localDataSource.updateMessage(sentMessage);

      return Right(sentMessage);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error occurred while sending message'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await _remoteDataSource.deleteMessage(messageId);
      await _localDataSource.deleteMessage(messageId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error occurred while deleting message'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(
    String chatRoomId,
    String messageId,
  ) async {
    try {
      await _remoteDataSource.markAsRead(chatRoomId, messageId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error occurred while marking as read'),
      );
    }
  }

  @override
  Future<Either<Failure, MediaMessage>> uploadMedia(
    String filePath,
    String messageId,
  ) async {
    try {
      final mediaMessage = await _remoteDataSource.uploadMedia(
        filePath,
        messageId,
      );
      await _localDataSource.insertMediaMessage(mediaMessage);
      return Right(mediaMessage);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error occurred while uploading media'),
      );
    }
  }

  @override
  Stream<List<Message>> watchMessages(String chatRoomId) {
    return _remoteDataSource
        .watchMessages(chatRoomId)
        .map((message) => [message]);
  }

  @override
  Stream<List<String>> watchTypingUsers(String chatRoomId) {
    return _remoteDataSource.watchTypingUsers(chatRoomId);
  }

  @override
  Future<Either<Failure, void>> updateTypingStatus(
    String chatRoomId,
    bool isTyping,
  ) async {
    try {
      await _remoteDataSource.updateTypingStatus(chatRoomId, isTyping);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error occurred while updating typing status'),
      );
    }
  }
}
