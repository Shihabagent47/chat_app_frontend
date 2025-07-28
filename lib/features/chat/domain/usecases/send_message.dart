import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase implements UseCase<Message, Message> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, Message>> call(Message params) async {
    try {
      final result = await repository.sendMessage(params);
      return result.fold(
        (error) => Left(ServerFailure('Failed to send message: $error')),
        (message) => Right(message),
      );
    } catch (e) {
      print('Failed to send message: $e');
      return Left(ServerFailure('Failed to send message'));
    }
  }
}
