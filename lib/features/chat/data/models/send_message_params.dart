import 'package:flutter/material.dart';

import '../../domain/entities/message.dart';

class SendMessageParams extends Message {
  final String? mediaPath;
  final String? mediaType;

  SendMessageParams({
    required String chatRoomId,
    required String content,
    this.mediaPath,
    this.mediaType,
    String? id,
    String? senderId,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    String? replyToId,
    Map<String, dynamic>? metadata,
  }) : super(
         id: id ?? UniqueKey().toString(), // or uuid
         senderId: senderId ?? '', // Will need to be filled later
         chatRoomId: chatRoomId,
         content: content,
         type: type ?? MessageType.text,
         status: status ?? MessageStatus.sending,
         timestamp: timestamp ?? DateTime.now(),
         replyToId: replyToId,
         metadata: metadata,
       );

  @override
  List<Object?> get props => super.props + [mediaPath, mediaType];
}
