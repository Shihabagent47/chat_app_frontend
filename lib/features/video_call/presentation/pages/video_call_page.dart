import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video_call_bloc.dart';
import '../bloc/video_call_event.dart';
import '../bloc/video_call_state.dart';
import '../bloc/call_controls_cubit.dart';
import '../widget/call_controls.dart';
import '../widget/call_status_indicator.dart';
import '../widget/video_renderer.dart';

class VideoCallPage extends StatefulWidget {
  final String callId;
  final bool isVideoCall;

  const VideoCallPage({
    Key? key,
    required this.callId,
    required this.isVideoCall,
  }) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  @override
  void initState() {
    super.initState();
    // Auto-hide controls after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        //  context.read<CallControlsCubit>().hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<VideoCallBloc, VideoCallState>(
        listener: (context, state) {
          // if (state.status == CallStatus.ended ||
          //     state.status == CallStatus.rejected) {
          //   Navigator.pop(context);
          // }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              // context.read<CallControlsCubit>().toggleVisibility();
            },
            child: Stack(
              children: [
                // Remote video (full screen)
                //      if (state.remoteStream != null && widget.isVideoCall)
                //         Positioned.fill(
                //           child: VideoRenderer(
                //             stream: state.remoteStream,
                //             mirror: false,
                //           ),
                //         ),

                // Local video (picture-in-picture)
                //  if (state.localStream != null && widget.isVideoCall)
                Positioned(
                  top: 60,
                  right: 20,
                  child: Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      // child: VideoRenderer(
                      //   stream: state.localStream,
                      //   mirror: true,
                      // ),
                    ),
                  ),
                ),

                // Audio-only call UI
                //   if (!widget.isVideoCall || state.remoteStream == null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey[800],
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Text(
                        //   state.recipientName ?? 'Unknown',
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 28,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                // Call status indicator
                const Positioned(
                  top: 60,
                  left: 20,
                  child: CallStatusIndicator(),
                ),

                // Call controls
                // BlocBuilder<CallControlsCubit, CallControlsState>(
                //   builder: (context, controlsState) {
                //     return AnimatedPositioned(
                //       duration: const Duration(milliseconds: 300),
                //       bottom:
                //           controlsState == CallControlsState.visible
                //               ? 80
                //               : -200,
                //       left: 0,
                //       right: 0,
                //       child: CallControls(
                //         callId: widget.callId,
                //         isVideoCall: widget.isVideoCall,
                //         isMuted: state.isMuted,
                //         isVideoEnabled: state.isVideoEnabled,
                //         isSpeakerEnabled: state.isSpeakerEnabled,
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
