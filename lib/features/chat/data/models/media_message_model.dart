import 'package:chat_app_user/features/chat/domain/entities/media_message.dart';

class MediaMessageModel extends MediaMessage {
  const MediaMessageModel({
    required super.id,
    required super.messageId,
    required super.fileName,
    required super.mimeType,
    required super.fileSize,
    super.thumbnailUrl,
    super.originalUrl,
    super.duration,
    super.width,
    super.height,
    super.metadata,
  });

  factory MediaMessageModel.fromJson(Map<String, dynamic> json) {
    return MediaMessageModel(
      id: json['id'],
      messageId: json['messageId'],
      fileName: json['fileName'],
      mimeType: json['mimeType'],
      fileSize: json['fileSize'],
      thumbnailUrl: json['thumbnailUrl'],
      originalUrl: json['originalUrl'],
      duration:
          json['duration'] != null
              ? Duration(milliseconds: json['duration'])
              : null,
      width: json['width'],
      height: json['height'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messageId': messageId,
      'fileName': fileName,
      'mimeType': mimeType,
      'fileSize': fileSize,
      'thumbnailUrl': thumbnailUrl,
      'originalUrl': originalUrl,
      'duration': duration?.inMilliseconds,
      'width': width,
      'height': height,
      'metadata': metadata,
    };
  }

  factory MediaMessageModel.fromEntity(MediaMessage mediaMessage) {
    return MediaMessageModel(
      id: mediaMessage.id,
      messageId: mediaMessage.messageId,
      fileName: mediaMessage.fileName,
      mimeType: mediaMessage.mimeType,
      fileSize: mediaMessage.fileSize,
      thumbnailUrl: mediaMessage.thumbnailUrl,
      originalUrl: mediaMessage.originalUrl,
      duration: mediaMessage.duration,
      width: mediaMessage.width,
      height: mediaMessage.height,
      metadata: mediaMessage.metadata,
    );
  }
}
