import 'package:dartz/dartz.dart';

import '../entities/chat_room.dart';
import '../repositories/chat_repository.dart';

class GetChatRoomsUseCase {
  final ChatRepository repository;

  GetChatRoomsUseCase(this.repository);

  Future<Either<Exception, List<ChatRoom>>> call() async {
    return await repository.getChatRooms();
  }
}
