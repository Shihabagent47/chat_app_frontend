import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class MarkAsReadParams {
  final String chatRoomId;
  final String messageId;

  MarkAsReadParams({required this.chatRoomId, required this.messageId});
}

class MarkAsReadUseCase implements UseCase<void, MarkAsReadParams> {
  final ChatRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) async {
    try {
      final result = await repository.markAsRead(
        params.chatRoomId,
        params.messageId,
      );
      return result.fold(
        (error) => Left(ServerFailure('Failed to mark as read: $error')),
        (success) => Right(success),
      );
    } catch (e) {
      print('Failed to mark as read: $e');
      return Left(ServerFailure('Failed to mark as read'));
    }
  }
}
