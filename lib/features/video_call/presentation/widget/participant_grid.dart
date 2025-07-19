import 'package:flutter/material.dart';
import 'video_renderer.dart';

class ParticipantGrid extends StatelessWidget {
  final List<dynamic> participants;
  final bool isVideoCall;

  const ParticipantGrid({
    Key? key,
    required this.participants,
    required this.isVideoCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const Center(
        child: Text('No participants', style: TextStyle(color: Colors.white)),
      );
    }

    if (participants.length == 1) {
      return VideoRenderer(stream: participants.first, mirror: false);
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: participants.length > 4 ? 3 : 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return VideoRenderer(stream: participants[index], mirror: false);
      },
    );
  }
}
