import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/model/paginated_list_response.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/chat_message_qury_params.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessagesParams {
  final String chatRoomId;
  final ChatMessageQueryParams queryParams;

  GetMessagesParams({required this.chatRoomId, required this.queryParams});
}

class GetMessagesUseCase
    implements UseCase<PaginatedListResponse<Message>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedListResponse<Message>>> call(
    GetMessagesParams params,
  ) async {
    try {
      final result = await repository.getMessages(
        params.chatRoomId,
        params.queryParams,
      );
      return result.fold(
        (error) => Left(ServerFailure('Failed to get messages: $error')),
        (messages) => Right(messages),
      );
    } catch (e) {
      print('Failed to get messages: $e');
      return Left(ServerFailure('Failed to get messages'));
    }
  }

  Stream<List<Message>> watch(String chatRoomId) {
    return repository.watchMessages(chatRoomId);
  }
}
