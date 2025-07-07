import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../models/peer_connection_model.dart';

abstract class WebRTCDataSource {
  Future<MediaStream> getUserMedia({required bool audio, required bool video});
  Future<RTCPeerConnection> createPeerConnection();
  Future<RTCSessionDescription> createOffer(RTCPeerConnection pc);
  Future<RTCSessionDescription> createAnswer(RTCPeerConnection pc);
  Future<void> setLocalDescription(
    RTCPeerConnection pc,
    RTCSessionDescription description,
  );
  Future<void> setRemoteDescription(
    RTCPeerConnection pc,
    RTCSessionDescription description,
  );
  Future<void> addIceCandidate(RTCPeerConnection pc, RTCIceCandidate candidate);
  Future<void> dispose();
}

class WebRTCDataSourceImpl implements WebRTCDataSource {
  final Map<String, RTCPeerConnection> _peerConnections = {};
  MediaStream? _localStream;

  @override
  Future<MediaStream> getUserMedia({
    required bool audio,
    required bool video,
  }) async {
    final constraints = {
      'audio': audio,
      'video': video ? {'facingMode': 'user'} : false,
    };

    _localStream = await navigator.mediaDevices.getUserMedia(constraints);
    return _localStream!;
  }

  @override
  Future<RTCPeerConnection> createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
      ],
    };

    final pc = await createPeerConnection();

    // Add local stream to peer connection
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        pc.addTrack(track, _localStream!);
      });
    }

    return pc;
  }

  @override
  Future<RTCSessionDescription> createOffer(RTCPeerConnection pc) async {
    final offer = await pc.createOffer();
    return offer;
  }

  @override
  Future<RTCSessionDescription> createAnswer(RTCPeerConnection pc) async {
    final answer = await pc.createAnswer();
    return answer;
  }

  @override
  Future<void> setLocalDescription(
    RTCPeerConnection pc,
    RTCSessionDescription description,
  ) async {
    await pc.setLocalDescription(description);
  }

  @override
  Future<void> setRemoteDescription(
    RTCPeerConnection pc,
    RTCSessionDescription description,
  ) async {
    await pc.setRemoteDescription(description);
  }

  @override
  Future<void> addIceCandidate(
    RTCPeerConnection pc,
    RTCIceCandidate candidate,
  ) async {
    await pc.addCandidate(candidate);
  }

  @override
  Future<void> dispose() async {
    await _localStream?.dispose();
    for (final pc in _peerConnections.values) {
      await pc.dispose();
    }
    _peerConnections.clear();
  }
}
