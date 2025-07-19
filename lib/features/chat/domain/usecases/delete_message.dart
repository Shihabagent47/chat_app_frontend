import 'package:dartz/dartz.dart';
import '../repositories/chat_repository.dart';

class DeleteMessageUseCase {
  final ChatRepository repository;

  DeleteMessageUseCase(this.repository);

  Future<Either<Exception, void>> call(String messageId) async {
    return await repository.deleteMessage(messageId);
  }
}
