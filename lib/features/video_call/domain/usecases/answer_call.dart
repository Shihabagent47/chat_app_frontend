import '../entities/call_session.dart';
import '../repositories/video_call_repository.dart';

class AnswerCall {
  final VideoCallRepository repository;

  AnswerCall(this.repository);

  Future<CallSession> call({
    required String callId,
    required bool accept,
  }) async {
    return await repository.answerCall(callId: callId, accept: accept);
  }
}
