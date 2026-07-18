import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/message_input_cubit.dart';
import '../bloc/typing_indicator_cubit.dart';
import '../widget/chat_message_list.dart';
import '../widget/message_bubble.dart';
import '../widget/message_input.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;

  const ChatRoomPage({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final ScrollController _scrollController = ScrollController();
  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<ChatBloc>();
    _chatBloc.add(LoadMessages(widget.chatRoomId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        (context.read<AuthBloc>().state.user?.id) ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MessageInputCubit()),
          BlocProvider(create: (context) => TypingIndicatorCubit()),
        ],
        child: Column(
          children: [
            Expanded(
              child: ChatMessageList(
                bloc: _chatBloc,
                chatRoomId: widget.chatRoomId,
                messageBuilder: (context, message, index) {
                  return MessageBubble(
                    message: message,
                    isMe: message.senderId == currentUserId,
                  );
                },
                emptyWidget: const Center(
                  child: Text('Start the conversation!'),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
            MessageInput(
              onSendMessage: (content) {
                _chatBloc.add(
                  SendMessage(
                    chatRoomId: widget.chatRoomId,
                    senderId: currentUserId,
                    content: content,
                  ),
                );
                Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
              },
            ),
          ],
        ),
      ),
    );
  }
}