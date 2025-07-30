import '../../../../core/bloc/generic_list_bloc.dart';
import '../../../../core/model/pagination_meta.dart';
import '../../../../core/model/query_params.dart';
import '../../domain/entities/message.dart';

abstract class ChatState extends GenericListState<Message> {
  const ChatState();
}

class ChatInitial extends ListInitial<Message> implements ChatState {}

class ChatLoading extends ListLoading<Message> implements ChatState {
  const ChatLoading({super.currentItems, super.isLoadingMore});
}

class MessagesLoaded extends ListLoaded<Message> implements ChatState {
  final String chatRoomId;
  final Map<String, bool> typingUsers;

  const MessagesLoaded({
    required super.items,
    required super.meta,
    required super.hasReachedMax,
    required this.chatRoomId,
    this.typingUsers = const {},
    super.currentQueryParams,
  });

  @override
  List<Object?> get props => [...super.props, chatRoomId, typingUsers];

  MessagesLoaded copyWith({
    List<Message>? messages,
    PaginationMeta? meta,
    bool? hasReachedMax,
    String? chatRoomId,
    Map<String, bool>? typingUsers,
    QueryParams? currentQueryParams,
  }) {
    return MessagesLoaded(
      items: messages ?? this.items,
      meta: meta ?? this.meta,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      typingUsers: typingUsers ?? this.typingUsers,
      currentQueryParams: currentQueryParams ?? this.currentQueryParams,
    );
  }
}

class ChatError extends ListError<Message> implements ChatState {
  const ChatError({required super.message, super.errors, super.currentItems});
}

class MessageSent extends ChatState {
  final Message message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageDeleted extends ChatState {
  final String messageId;

  const MessageDeleted(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
