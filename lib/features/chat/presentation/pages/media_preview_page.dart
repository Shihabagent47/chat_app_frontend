import 'package:flutter/material.dart';
import 'dart:io';

class MediaPreviewPage extends StatelessWidget {
  final String mediaPath;
  final String mediaType;
  final String? caption;

  const MediaPreviewPage({
    Key? key,
    required this.mediaPath,
    required this.mediaType,
    this.caption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // Download functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Center(child: _buildMediaWidget())),
          if (caption != null && caption!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Colors.black54,
              child: Text(
                caption!,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaWidget() {
    if (mediaType.startsWith('image/')) {
      return InteractiveViewer(
        panEnabled: true,
        boundaryMargin: EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.file(File(mediaPath), fit: BoxFit.contain),
      );
    } else if (mediaType.startsWith('video/')) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_filled, size: 80, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Video Preview',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Tap to play',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file, size: 80, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'File Preview',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Tap to open',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }
  }
}
