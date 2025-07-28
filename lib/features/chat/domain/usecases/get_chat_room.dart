import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/model/paginated_list_response.dart';
import '../../../chat/data/models/chat_query_params.dart';
import '../entities/chat_room.dart';
import '../repositories/chat_repository.dart';

class GetChatRoomsUseCase
    implements UseCase<PaginatedListResponse<ChatRoom>, ChatQueryParams> {
  final ChatRepository repository;

  GetChatRoomsUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedListResponse<ChatRoom>>> call(
    ChatQueryParams params,
  ) async {
    try {
      final result = await repository.getChatRooms(params);
      return result.fold(
        (failure) => Left(failure),
        (chatRooms) => Right(chatRooms),
      );
    } catch (e) {
      print('Failed to get chat rooms: $e');
      return Left(ServerFailure('Failed to get chat rooms'));
    }
  }
}
