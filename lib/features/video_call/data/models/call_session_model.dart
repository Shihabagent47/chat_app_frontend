import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_participant.dart';

class CallSessionModel extends CallSession {
  const CallSessionModel({
    required super.id,
    required super.callerId,
    required super.receiverId,
    required super.type,
    required super.status,
    required super.startTime,
    super.endTime,
    required super.participants,
  });

  factory CallSessionModel.fromJson(Map<String, dynamic> json) {
    return CallSessionModel(
      id: json['id'],
      callerId: json['caller_id'],
      receiverId: json['receiver_id'],
      type: CallType.values[json['type']],
      status: CallStatus.values[json['status']],
      startTime: DateTime.parse(json['start_time']),
      endTime:
          json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      participants:
          (json['participants'] as List)
              .map((p) => CallParticipantModel.fromJson(p))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caller_id': callerId,
      'receiver_id': receiverId,
      'type': type.index,
      'status': status.index,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'participants':
          participants
              .map((p) => (p as CallParticipantModel).toJson())
              .toList(),
    };
  }
}

class CallParticipantModel extends CallParticipant {
  const CallParticipantModel({
    required super.id,
    required super.name,
    super.avatarUrl,
    super.isAudioMuted,
    super.isVideoMuted,
    super.isConnected,
    required super.role,
  });

  factory CallParticipantModel.fromJson(Map<String, dynamic> json) {
    return CallParticipantModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
      isAudioMuted: json['is_audio_muted'] ?? false,
      isVideoMuted: json['is_video_muted'] ?? false,
      isConnected: json['is_connected'] ?? false,
      role: ParticipantRole.values[json['role']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'is_audio_muted': isAudioMuted,
      'is_video_muted': isVideoMuted,
      'is_connected': isConnected,
      'role': role.index,
    };
  }
}
