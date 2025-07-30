import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_state.dart';
import '../bloc/chat_event.dart';
import '../bloc/message_input_cubit.dart';
import '../bloc/typing_indicator_cubit.dart';
import '../widget/chat_message_list.dart';
import '../widget/message_bubble.dart';
import '../widget/message_input.dart';
import '../widget/typing_indicator.dart';

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
    // Load initial messages
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show chat options
            },
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
            // Option 1: Using the chat-specific widget
            Expanded(
              child: ChatMessageList(
                bloc: _chatBloc,
                chatRoomId: widget.chatRoomId,
                messageBuilder: (context, message, index) {
                  return MessageBubble(
                    message: message,
                    isMe:
                        message.senderId ==
                        getCurrentUserId(), // Implement this
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

            // Message input
            MessageInput(
              onSendMessage: (content) {
                _chatBloc.add(
                  SendMessage(chatRoomId: widget.chatRoomId, content: content),
                );
                // Scroll to bottom after sending message
                Future.delayed(const Duration(milliseconds: 100), () {
                  _scrollToBottom();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function - implement based on your auth system
String getCurrentUserId() {
  // TODO: Implement this
  return 'current_user_id';
}
