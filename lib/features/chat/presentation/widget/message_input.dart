import 'package:flutter/material.dart';

import '../../domain/entities/message.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String)? onTyping;
  final VoidCallback? onStopTyping;
  final String? hintText;
  final bool enabled;
  final Widget? leading;
  final List<Widget>? actions;

  const MessageInput({
    Key? key,
    required this.onSendMessage,
    this.onTyping,
    this.onStopTyping,
    this.hintText,
    this.enabled = true,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _textController = TextEditingController();
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
      _onStopTyping();
    }
  }

  void _onTyping() {
    if (!_isTyping) {
      _isTyping = true;
      widget.onTyping?.call(_textController.text);
    }
  }

  void _onStopTyping() {
    if (_isTyping) {
      _isTyping = false;
      widget.onStopTyping?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
      ),
      child: Row(
        children: [
          // Leading widget (e.g., attach button)
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: 8),
          ],

          // Text input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      enabled: widget.enabled,
                      onChanged: (text) {
                        if (text.isNotEmpty) {
                          _onTyping();
                        } else {
                          _onStopTyping();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? "Type a message...",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),

                  // Send button
                  IconButton(
                    onPressed: widget.enabled ? _sendMessage : null,
                    icon: Icon(
                      Icons.send,
                      color:
                          _textController.text.trim().isEmpty
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Additional actions
          if (widget.actions != null) ...[
            const SizedBox(width: 8),
            ...widget.actions!,
          ],
        ],
      ),
    );
  }
}
