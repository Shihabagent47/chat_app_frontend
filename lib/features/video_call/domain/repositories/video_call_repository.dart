import '../entities/call_session.dart';
import '../entities/call_participant.dart';

abstract class VideoCallRepository {
  Future<CallSession> initiateCall({
    required String receiverId,
    required CallType type,
  });

  Future<CallSession> answerCall({
    required String callId,
    required bool accept,
  });

  Future<void> endCall(String callId);

  Future<void> toggleCamera();
  Future<void> toggleMicrophone();
  Future<void> switchCamera();

  Stream<CallSession> watchCallSession(String callId);
  Stream<List<CallParticipant>> watchParticipants(String callId);
  Stream<CallStatus> watchCallStatus(String callId);

  Future<List<CallSession>> getCallHistory();
}
