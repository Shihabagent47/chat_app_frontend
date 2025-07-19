import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video_call_bloc.dart';
import '../bloc/video_call_event.dart';
import '../bloc/video_call_state.dart';

class IncomingCallPage extends StatelessWidget {
  final String callId;
  final String callerName;
  final String? callerAvatarUrl;
  final bool isVideoCall;

  const IncomingCallPage({
    Key? key,
    required this.callId,
    required this.callerName,
    this.callerAvatarUrl,
    required this.isVideoCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<VideoCallBloc, VideoCallState>(
        listener: (context, state) {
          // if (state.status == CallStatus.connected) {
          //   Navigator.pushReplacementNamed(
          //     context,
          //     '/video-call',
          //     arguments: {'callId': callId, 'isVideoCall': isVideoCall},
          //   );
          // } else if (state.status == CallStatus.rejected ||
          //     state.status == CallStatus.ended) {
          //   Navigator.pop(context);
          // }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  isVideoCall ? 'Incoming video call' : 'Incoming call',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[800],
                  backgroundImage:
                      callerAvatarUrl != null
                          ? NetworkImage(callerAvatarUrl!)
                          : null,
                  child:
                      callerAvatarUrl == null
                          ? Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey[400],
                          )
                          : null,
                ),
                const SizedBox(height: 24),
                Text(
                  callerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reject button
                    GestureDetector(
                      onTap: () {
                        // context.read<VideoCallBloc>().add(
                        //   RejectCallEvent(callId: callId),
                        // );
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    // Answer button
                    GestureDetector(
                      onTap: () {
                        // context.read<VideoCallBloc>().add(
                        //   AnswerCallEvent(
                        //     callId: callId,
                        //     acceptWithVideo: isVideoCall,
                        //   ),
                        // );
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}
