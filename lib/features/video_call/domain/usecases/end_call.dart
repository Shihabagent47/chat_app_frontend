import '../repositories/video_call_repository.dart';

class EndCall {
  final VideoCallRepository repository;

  EndCall(this.repository);

  Future<void> call(String callId) async {
    await repository.endCall(callId);
  }
}
