import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoRenderer extends StatefulWidget {
  final MediaStream? stream;
  final bool mirror;

  const VideoRenderer({Key? key, required this.stream, this.mirror = false})
    : super(key: key);

  @override
  State<VideoRenderer> createState() => _VideoRendererState();
}

class _VideoRendererState extends State<VideoRenderer> {
  RTCVideoRenderer? _renderer;

  @override
  void initState() {
    super.initState();
    _initRenderer();
  }

  void _initRenderer() async {
    _renderer = RTCVideoRenderer();
    await _renderer!.initialize();
    if (widget.stream != null) {
      _renderer!.srcObject = widget.stream;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(VideoRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _renderer?.srcObject = widget.stream;
    }
  }

  @override
  void dispose() {
    _renderer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_renderer == null) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Transform(
      alignment: Alignment.center,
      transform:
          widget.mirror ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
      child: RTCVideoView(
        _renderer!,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      ),
    );
  }
}
