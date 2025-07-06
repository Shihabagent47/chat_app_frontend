import '../entities/call_session.dart';
import '../repositories/video_call_repository.dart';

class InitiateCall {
  final VideoCallRepository repository;

  InitiateCall(this.repository);

  Future<CallSession> call({
    required String receiverId,
    required CallType type,
  }) async {
    return await repository.initiateCall(receiverId: receiverId, type: type);
  }
}
