import 'package:flutter_bloc/flutter_bloc.dart';

class MessageInputState {
  final String text;
  final bool isTyping;
  final List<String> attachments;

  MessageInputState({
    this.text = '',
    this.isTyping = false,
    this.attachments = const [],
  });

  MessageInputState copyWith({
    String? text,
    bool? isTyping,
    List<String>? attachments,
  }) {
    return MessageInputState(
      text: text ?? this.text,
      isTyping: isTyping ?? this.isTyping,
      attachments: attachments ?? this.attachments,
    );
  }
}

class MessageInputCubit extends Cubit<MessageInputState> {
  MessageInputCubit() : super(MessageInputState());

  void updateText(String text) {
    emit(state.copyWith(text: text));
  }

  void setTyping(bool isTyping) {
    emit(state.copyWith(isTyping: isTyping));
  }

  void addAttachment(String path) {
    final updatedAttachments = [...state.attachments, path];
    emit(state.copyWith(attachments: updatedAttachments));
  }

  void removeAttachment(String path) {
    final updatedAttachments =
        state.attachments.where((a) => a != path).toList();
    emit(state.copyWith(attachments: updatedAttachments));
  }

  void clearInput() {
    emit(MessageInputState());
  }
}
