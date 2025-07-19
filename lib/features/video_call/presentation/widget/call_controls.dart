import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video_call_bloc.dart';
import '../bloc/video_call_event.dart';

class CallControls extends StatelessWidget {
  final String callId;
  final bool isVideoCall;
  final bool isMuted;
  final bool isVideoEnabled;
  final bool isSpeakerEnabled;

  const CallControls({
    Key? key,
    required this.callId,
    required this.isVideoCall,
    required this.isMuted,
    required this.isVideoEnabled,
    required this.isSpeakerEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute button
          _buildControlButton(
            icon: isMuted ? Icons.mic_off : Icons.mic,
            isActive: !isMuted,
            onTap: () {
              // TODO: Implement mute toggle
            },
          ),

          // Video toggle (only for video calls)
          if (isVideoCall)
            _buildControlButton(
              icon: isVideoEnabled ? Icons.videocam : Icons.videocam_off,
              isActive: isVideoEnabled,
              onTap: () {
                // TODO: Implement video toggle
              },
            ),

          // Speaker button
          _buildControlButton(
            icon: isSpeakerEnabled ? Icons.volume_up : Icons.volume_down,
            isActive: isSpeakerEnabled,
            onTap: () {
              // TODO: Implement speaker toggle
            },
          ),

          // End call button
          _buildControlButton(
            icon: Icons.call_end,
            isActive: false,
            backgroundColor: Colors.red,
            onTap: () {
              //  context.read<VideoCallBloc>().add(EndCallEvent(callId: callId));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    Color? backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (isActive ? Colors.grey[800] : Colors.grey[600]),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
