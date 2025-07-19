import 'package:equatable/equatable.dart';
import '../../domain/entities/call_session.dart';

abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object?> get props => [];
}

class InitiateCallEvent extends VideoCallEvent {
  final String receiverId;
  final CallType type;

  const InitiateCallEvent({required this.receiverId, required this.type});

  @override
  List<Object?> get props => [receiverId, type];
}

class AnswerCallEvent extends VideoCallEvent {
  final String callId;
  final bool accept;

  const AnswerCallEvent({required this.callId, required this.accept});

  @override
  List<Object?> get props => [callId, accept];
}

class EndCallEvent extends VideoCallEvent {
  final String callId;

  const EndCallEvent(this.callId);

  @override
  List<Object?> get props => [callId];
}

class ToggleCameraEvent extends VideoCallEvent {}

class ToggleMicrophoneEvent extends VideoCallEvent {}

class SwitchCameraEvent extends VideoCallEvent {}

class CallSessionUpdatedEvent extends VideoCallEvent {
  final CallSession callSession;

  const CallSessionUpdatedEvent(this.callSession);

  @override
  List<Object?> get props => [callSession];
}
