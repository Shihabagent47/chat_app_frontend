import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/call_session.dart';
import '../bloc/video_call_bloc.dart';
import '../bloc/video_call_state.dart';

class CallStatusIndicator extends StatelessWidget {
  const CallStatusIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCallBloc, VideoCallState>(
      builder: (context, state) {
        String statusText = '';
        Color statusColor = Colors.white;

        // switch (state.status) {
        //   case CallStatus.initiating:
        //     statusText = 'Initiating call...';
        //     statusColor = Colors.orange;
        //     break;
        //   case CallStatus.ringing:
        //     statusText = 'Ringing...';
        //     statusColor = Colors.blue;
        //     break;
        //   case CallStatus.connecting:
        //     statusText = 'Connecting...';
        //     statusColor = Colors.orange;
        //     break;
        //   case CallStatus.connected:
        //     statusText = _formatDuration(state.callDuration ?? Duration.zero);
        //     statusColor = Colors.green;
        //     break;
        //   case CallStatus.ended:
        //     statusText = 'Call ended';
        //     statusColor = Colors.red;
        //     break;
        //   case CallStatus.rejected:
        //     statusText = 'Call rejected';
        //     statusColor = Colors.red;
        //     break;
        //   case CallStatus.failed:
        //     statusText = 'Call failed';
        //     statusColor = Colors.red;
        //     break;
        //   default:
        //     statusText = '';
        // }

        if (statusText.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
