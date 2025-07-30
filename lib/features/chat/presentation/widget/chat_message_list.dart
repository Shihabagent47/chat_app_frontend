import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/generic_list_bloc.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatMessageList extends StatefulWidget {
  final ChatBloc bloc;
  final Widget Function(BuildContext context, Message message, int index)
  messageBuilder;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final bool enableRefresh;
  final EdgeInsets? padding;
  final String chatRoomId;

  const ChatMessageList({
    Key? key,
    required this.bloc,
    required this.messageBuilder,
    required this.chatRoomId,
    this.emptyWidget,
    this.loadingWidget,
    this.enableRefresh = true,
    this.padding,
  }) : super(key: key);

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasReachedMax = false;
  bool _shouldScrollToBottom = false;
  int _previousItemCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data
    widget.bloc.add(LoadMessages(widget.chatRoomId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if user scrolled to the top (for loading older messages)
    if (_isTop && !_isLoadingMore && !_hasReachedMax) {
      _loadMore();
    }
  }

  bool get _isTop {
    if (!_scrollController.hasClients) return false;
    final currentScroll = _scrollController.offset;
    // Trigger loading when user is 200 pixels from the top
    return currentScroll <= 200;
  }

  bool get _isAtBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 100);
  }

  void _loadMore() {
    if (!_isLoadingMore && !_hasReachedMax) {
      setState(() {
        _isLoadingMore = true;
      });
      widget.bloc.add(LoadMore());
    }
  }

  void _scrollToBottom({bool animate = true}) {
    if (_scrollController.hasClients) {
      if (animate) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  void _maintainScrollPosition(int oldItemCount, int newItemCount) {
    if (_scrollController.hasClients && oldItemCount > 0) {
      // Calculate how many new items were added at the beginning
      final newItemsAdded = newItemCount - oldItemCount;
      if (newItemsAdded > 0) {
        // Estimate the height of new items and adjust scroll position
        // This is a rough estimate - you might need to adjust based on your message heights
        final estimatedItemHeight =
            60.0; // Adjust this based on your message height
        final scrollOffset = newItemsAdded * estimatedItemHeight;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.offset + scrollOffset);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, GenericListState<Message>>(
      bloc: widget.bloc,
      listener: (context, state) {
        // Update local loading state based on bloc state
        if (state is MessagesLoaded) {
          final oldCount = _previousItemCount;
          _previousItemCount = state.items.length;

          _isLoadingMore = false;
          _hasReachedMax = state.hasReachedMax;

          // If this is the first load or a new message was added, scroll to bottom
          if (oldCount == 0 ||
              (oldCount > 0 && state.items.length > oldCount && _isAtBottom)) {
            _shouldScrollToBottom = true;
          } else if (oldCount > 0 && state.items.length > oldCount) {
            // Maintain scroll position when loading older messages
            _maintainScrollPosition(oldCount, state.items.length);
          }
        } else if (state is ChatLoading) {
          _isLoadingMore = state.isLoadingMore;
        } else if (state is ChatError) {
          _isLoadingMore = false;
        }

        // Handle new message sent - scroll to bottom
        if (state is MessageSent) {
          _shouldScrollToBottom = true;
        }
      },
      child: BlocBuilder<ChatBloc, GenericListState<Message>>(
        bloc: widget.bloc,
        builder: (context, state) {
          // Handle initial loading state
          if (state is ListInitial<Message> ||
              (state is ChatLoading && state.currentItems.isEmpty)) {
            return widget.loadingWidget ??
                const Center(child: CircularProgressIndicator());
          }

          // Handle error state with no items
          if (state is ChatError && state.currentItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _isLoadingMore = false;
                      _hasReachedMax = false;
                      widget.bloc.add(
                        LoadMessages(widget.chatRoomId, refresh: true),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Extract messages from current state
          List<Message> messages = [];
          bool showTopLoader = false;

          if (state is MessagesLoaded) {
            messages = state.items;
            _hasReachedMax = state.hasReachedMax;
            showTopLoader = false;
          } else if (state is ChatLoading) {
            messages = state.currentItems;
            showTopLoader = state.isLoadingMore && messages.isNotEmpty;
          } else if (state is ChatError) {
            messages = state.currentItems;
            showTopLoader = false;
          }

          // Handle empty state
          if (messages.isEmpty) {
            return widget.emptyWidget ??
                const Center(
                  child: Text('No messages yet. Start the conversation!'),
                );
          }

          // Schedule scroll to bottom if needed
          if (_shouldScrollToBottom) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
              _shouldScrollToBottom = false;
            });
          }

          // Build the list view (reversed for chat)
          Widget listView = ListView.builder(
            controller: _scrollController,
            padding: widget.padding ?? const EdgeInsets.all(8.0),
            // Reverse the list so newest messages appear at bottom
            reverse: false, // We'll handle the order in the data
            itemCount: messages.length + (showTopLoader ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the top
              if (showTopLoader && index == 0) {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  child: const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              // Adjust index if there's a top loader
              final messageIndex = showTopLoader ? index - 1 : index;
              return widget.messageBuilder(
                context,
                messages[messageIndex],
                messageIndex,
              );
            },
          );

          // Add pull-to-refresh if enabled (pulls down to refresh)
          if (widget.enableRefresh) {
            return RefreshIndicator(
              onRefresh: () async {
                _isLoadingMore = false;
                _hasReachedMax = false;
                widget.bloc.add(LoadMessages(widget.chatRoomId, refresh: true));
                // Wait for the refresh to complete
                await widget.bloc.stream.firstWhere(
                  (state) => state is! ChatLoading,
                );
              },
              child: listView,
            );
          }

          return listView;
        },
      ),
    );
  }
}

// Extension to add scroll to bottom method that can be called from parent
extension ChatMessageListController on _ChatMessageListState {
  void scrollToBottom({bool animate = true}) {
    _scrollToBottom(animate: animate);
  }
}
