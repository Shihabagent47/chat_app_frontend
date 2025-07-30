import '../../../../core/bloc/generic_list_bloc.dart';
import '../../../../core/model/query_params.dart';
import '../../domain/entities/message.dart';

abstract class ChatEvent extends GenericListEvent {
  const ChatEvent();
}

class LoadMessages extends LoadList {
  final String chatRoomId;

  const LoadMessages(
    this.chatRoomId, {
    QueryParams? queryParams,
    bool refresh = false,
  }) : super(queryParams: queryParams, refresh: refresh);

  @override
  List<Object?> get props => [chatRoomId, ...super.props];
}

class SendMessage extends ChatEvent {
  final String chatRoomId;
  final String content;
  final String? mediaPath;
  final String? mediaType;

  const SendMessage({
    required this.chatRoomId,
    required this.content,
    this.mediaPath,
    this.mediaType,
  });

  @override
  List<Object?> get props => [chatRoomId, content, mediaPath, mediaType];
}

class DeleteMessage extends ChatEvent {
  final String messageId;

  const DeleteMessage(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class MarkAsRead extends ChatEvent {
  final String chatRoomId;
  final String messageId;

  const MarkAsRead({required this.chatRoomId, required this.messageId});

  @override
  List<Object?> get props => [chatRoomId, messageId];
}

class MessageReceived extends ChatEvent {
  final Message message;

  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class UserTyping extends ChatEvent {
  final String userId;
  final bool isTyping;

  const UserTyping({required this.userId, required this.isTyping});

  @override
  List<Object?> get props => [userId, isTyping];
}
