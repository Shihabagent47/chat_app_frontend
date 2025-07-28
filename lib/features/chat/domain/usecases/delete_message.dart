import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class DeleteMessageParams {
  final String messageId;

  DeleteMessageParams({required this.messageId});
}

class DeleteMessageUseCase implements UseCase<void, DeleteMessageParams> {
  final ChatRepository repository;

  DeleteMessageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteMessageParams params) async {
    try {
      final result = await repository.deleteMessage(params.messageId);
      return result.fold(
        (error) => Left(ServerFailure('Failed to delete message: $error')),
        (success) => Right(success),
      );
    } catch (e) {
      print('Failed to delete message: $e');
      return Left(ServerFailure('Failed to delete message'));
    }
  }
}
