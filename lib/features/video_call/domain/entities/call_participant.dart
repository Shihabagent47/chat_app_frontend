class CallParticipant {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isAudioMuted;
  final bool isVideoMuted;
  final bool isConnected;
  final ParticipantRole role;

  const CallParticipant({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isAudioMuted = false,
    this.isVideoMuted = false,
    this.isConnected = false,
    required this.role,
  });

  CallParticipant copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isAudioMuted,
    bool? isVideoMuted,
    bool? isConnected,
    ParticipantRole? role,
  }) {
    return CallParticipant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAudioMuted: isAudioMuted ?? this.isAudioMuted,
      isVideoMuted: isVideoMuted ?? this.isVideoMuted,
      isConnected: isConnected ?? this.isConnected,
      role: role ?? this.role,
    );
  }
}

enum ParticipantRole { caller, receiver }
