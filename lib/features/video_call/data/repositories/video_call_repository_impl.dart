import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/repositories/video_call_repository.dart';
import '../datasources/webrtc_datasource.dart';
import '../datasources/call_signaling_datasource.dart';
import '../models/call_session_model.dart';

class VideoCallRepositoryImpl implements VideoCallRepository {
  final WebRTCDataSource webRTCDataSource;
  final CallSignalingDataSource signalingDataSource;

  VideoCallRepositoryImpl({
    required this.webRTCDataSource,
    required this.signalingDataSource,
  });

  @override
  Future<CallSession> initiateCall({
    required String receiverId,
    required CallType type,
  }) async {
    final callSession = await signalingDataSource.initiateCall(
      receiverId,
      type.name,
    );

    // Setup WebRTC connection
    await _setupWebRTCConnection();

    return callSession;
  }

  @override
  Future<CallSession> answerCall({
    required String callId,
    required bool accept,
  }) async {
    await signalingDataSource.answerCall(callId, accept);

    if (accept) {
      await _setupWebRTCConnection();
    }

    // Return updated call session
    return CallSessionModel(
      id: callId,
      callerId: '',
      receiverId: '',
      type: CallType.video,
      status: accept ? CallStatus.connecting : CallStatus.rejected,
      startTime: DateTime.now(),
      participants: [],
    );
  }

  @override
  Future<void> endCall(String callId) async {
    await signalingDataSource.endCall(callId);
    await webRTCDataSource.dispose();
  }

  @override
  Future<void> toggleCamera() async {
    // Implementation for toggling camera
  }

  @override
  Future<void> toggleMicrophone() async {
    // Implementation for toggling microphone
  }

  @override
  Future<void> switchCamera() async {
    // Implementation for switching camera
  }

  @override
  Stream<CallSession> watchCallSession(String callId) {
    return signalingDataSource
        .onSignal('call_updated')
        .map((data) => CallSessionModel.fromJson(data));
  }

  @override
  Stream<List<CallParticipant>> watchParticipants(String callId) {
    return signalingDataSource
        .onSignal('participants_updated')
        .map(
          (data) =>
              (data['participants'] as List)
                  .map((p) => CallParticipantModel.fromJson(p))
                  .toList(),
        );
  }

  @override
  Stream<CallStatus> watchCallStatus(String callId) {
    return signalingDataSource
        .onSignal('call_status_changed')
        .map((data) => CallStatus.values[data['status']]);
  }

  @override
  Future<List<CallSession>> getCallHistory() async {
    // Implementation for call history
    return [];
  }

  Future<void> _setupWebRTCConnection() async {
    await webRTCDataSource.getUserMedia(audio: true, video: true);
    await webRTCDataSource.createPeerConnection();
  }
}
