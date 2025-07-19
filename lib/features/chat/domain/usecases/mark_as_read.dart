import 'package:dartz/dartz.dart';
import '../repositories/chat_repository.dart';

class MarkAsReadUseCase {
  final ChatRepository repository;

  MarkAsReadUseCase(this.repository);

  Future<Either<Exception, void>> call(
    String chatRoomId,
    String messageId,
  ) async {
    return await repository.markAsRead(chatRoomId, messageId);
  }
}
