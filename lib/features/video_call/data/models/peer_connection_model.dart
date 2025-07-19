import 'package:flutter_webrtc/flutter_webrtc.dart';

class PeerConnectionModel {
  final String id;
  final RTCPeerConnection peerConnection;
  final MediaStream? localStream;
  final MediaStream? remoteStream;
  final bool isConnected;
  final List<RTCIceCandidate> iceCandidates;

  PeerConnectionModel({
    required this.id,
    required this.peerConnection,
    this.localStream,
    this.remoteStream,
    this.isConnected = false,
    this.iceCandidates = const [],
  });

  PeerConnectionModel copyWith({
    String? id,
    RTCPeerConnection? peerConnection,
    MediaStream? localStream,
    MediaStream? remoteStream,
    bool? isConnected,
    List<RTCIceCandidate>? iceCandidates,
  }) {
    return PeerConnectionModel(
      id: id ?? this.id,
      peerConnection: peerConnection ?? this.peerConnection,
      localStream: localStream ?? this.localStream,
      remoteStream: remoteStream ?? this.remoteStream,
      isConnected: isConnected ?? this.isConnected,
      iceCandidates: iceCandidates ?? this.iceCandidates,
    );
  }
}
