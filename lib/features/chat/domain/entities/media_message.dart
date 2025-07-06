import 'package:equatable/equatable.dart';

class MediaMessage extends Equatable {
  final String id;
  final String messageId;
  final String fileName;
  final String mimeType;
  final int fileSize;
  final String? thumbnailUrl;
  final String? originalUrl;
  final Duration? duration; // for audio/video
  final int? width; // for images/video
  final int? height; // for images/video
  final Map<String, dynamic>? metadata;

  const MediaMessage({
    required this.id,
    required this.messageId,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
    this.thumbnailUrl,
    this.originalUrl,
    this.duration,
    this.width,
    this.height,
    this.metadata,
  });

  MediaMessage copyWith({
    String? id,
    String? messageId,
    String? fileName,
    String? mimeType,
    int? fileSize,
    String? thumbnailUrl,
    String? originalUrl,
    Duration? duration,
    int? width,
    int? height,
    Map<String, dynamic>? metadata,
  }) {
    return MediaMessage(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      originalUrl: originalUrl ?? this.originalUrl,
      duration: duration ?? this.duration,
      width: width ?? this.width,
      height: height ?? this.height,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    messageId,
    fileName,
    mimeType,
    fileSize,
    thumbnailUrl,
    originalUrl,
    duration,
    width,
    height,
    metadata,
  ];
}
