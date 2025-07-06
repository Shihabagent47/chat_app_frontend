import 'package:dartz/dartz.dart';
import '../repositories/chat_repository.dart';

class DeleteMessage {
  final ChatRepository repository;

  DeleteMessage(this.repository);

  Future<Either<Exception, void>> call(String messageId) async {
    return await repository.deleteMessage(messageId);
  }
}
