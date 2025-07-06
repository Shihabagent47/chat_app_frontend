import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Exception, Message>> call(Message message) async {
    return await repository.sendMessage(message);
  }
}
