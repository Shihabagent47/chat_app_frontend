import 'package:chat_app_user/features/video_call/domain/entities/call_participant.dart';

class CallSession {
  final String id;
  final String callerId;
  final String receiverId;
  final CallType type;
  final CallStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final List<CallParticipant> participants;

  const CallSession({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.participants,
  });

  CallSession copyWith({
    String? id,
    String? callerId,
    String? receiverId,
    CallType? type,
    CallStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    List<CallParticipant>? participants,
  }) {
    return CallSession(
      id: id ?? this.id,
      callerId: callerId ?? this.callerId,
      receiverId: receiverId ?? this.receiverId,
      type: type ?? this.type,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      participants: participants ?? this.participants,
    );
  }

  Duration get duration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return DateTime.now().difference(startTime);
  }
}

enum CallType { audio, video }

enum CallStatus { calling, connecting, connected, ended, rejected, missed }
