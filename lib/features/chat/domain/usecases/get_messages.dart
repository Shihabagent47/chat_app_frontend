import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Future<Either<Exception, List<Message>>> call(String chatRoomId) async {
    return await repository.getMessages(chatRoomId);
  }

  Stream<List<Message>> watch(String chatRoomId) {
    return repository.watchMessages(chatRoomId);
  }
}
