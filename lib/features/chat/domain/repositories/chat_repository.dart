import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/model/paginated_list_response.dart';
import '../../data/models/chat_query_params.dart';
import '../entities/message.dart';
import '../entities/chat_room.dart';
import '../entities/media_message.dart';

abstract class ChatRepository {
  Future<Either<Failure, PaginatedListResponse<ChatRoom>>> getChatRooms(
    ChatQueryParams params,
  );
  Future<Either<Failure, List<Message>>> getMessages(String chatRoomId);
  Future<Either<Failure, Message>> sendMessage(Message message);
  Future<Either<Failure, void>> deleteMessage(String messageId);
  Future<Either<Failure, void>> markAsRead(String chatRoomId, String messageId);
  Future<Either<Failure, MediaMessage>> uploadMedia(
    String filePath,
    String messageId,
  );
  Stream<List<Message>> watchMessages(String chatRoomId);
  Stream<List<String>> watchTypingUsers(String chatRoomId);
  Future<Either<Failure, void>> updateTypingStatus(
    String chatRoomId,
    bool isTyping,
  );
}
