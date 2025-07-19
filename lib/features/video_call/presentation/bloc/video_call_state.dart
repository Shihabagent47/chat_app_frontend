import 'package:equatable/equatable.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_participant.dart';

abstract class VideoCallState extends Equatable {
  const VideoCallState();

  @override
  List<Object?> get props => [];
}

class VideoCallInitial extends VideoCallState {}

class VideoCallLoading extends VideoCallState {}

class VideoCallInProgress extends VideoCallState {
  final CallSession callSession;
  final List<CallParticipant> participants;
  final bool isCameraOn;
  final bool isMicrophoneOn;

  const VideoCallInProgress({
    required this.callSession,
    required this.participants,
    this.isCameraOn = true,
    this.isMicrophoneOn = true,
  });

  @override
  List<Object?> get props => [
    callSession,
    participants,
    isCameraOn,
    isMicrophoneOn,
  ];

  VideoCallInProgress copyWith({
    CallSession? callSession,
    List<CallParticipant>? participants,
    bool? isCameraOn,
    bool? isMicrophoneOn,
  }) {
    return VideoCallInProgress(
      callSession: callSession ?? this.callSession,
      participants: participants ?? this.participants,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isMicrophoneOn: isMicrophoneOn ?? this.isMicrophoneOn,
    );
  }
}

class VideoCallEnded extends VideoCallState {
  final CallSession callSession;

  const VideoCallEnded(this.callSession);

  @override
  List<Object?> get props => [callSession];
}

class VideoCallError extends VideoCallState {
  final String message;

  const VideoCallError(this.message);

  @override
  List<Object?> get props => [message];
}

class IncomingCallState extends VideoCallState {
  final CallSession callSession;

  const IncomingCallState(this.callSession);

  @override
  List<Object?> get props => [callSession];
}
