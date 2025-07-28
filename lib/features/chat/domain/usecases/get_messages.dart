import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessagesParams {
  final String chatRoomId;

  GetMessagesParams({required this.chatRoomId});
}

class GetMessagesUseCase implements UseCase<List<Message>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesParams params) async {
    try {
      final result = await repository.getMessages(params.chatRoomId);
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
