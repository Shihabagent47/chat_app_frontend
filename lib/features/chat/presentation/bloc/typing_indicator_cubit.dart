import 'package:flutter_bloc/flutter_bloc.dart';

class TypingIndicatorState {
  final List<String> typingUsers;
  final bool isVisible;

  TypingIndicatorState({this.typingUsers = const [], this.isVisible = false});

  TypingIndicatorState copyWith({List<String>? typingUsers, bool? isVisible}) {
    return TypingIndicatorState(
      typingUsers: typingUsers ?? this.typingUsers,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class TypingIndicatorCubit extends Cubit<TypingIndicatorState> {
  TypingIndicatorCubit() : super(TypingIndicatorState());

  void updateTypingUsers(List<String> users) {
    emit(state.copyWith(typingUsers: users, isVisible: users.isNotEmpty));
  }

  void addTypingUser(String userId) {
    if (!state.typingUsers.contains(userId)) {
      final updatedUsers = [...state.typingUsers, userId];
      emit(state.copyWith(typingUsers: updatedUsers, isVisible: true));
    }
  }

  void removeTypingUser(String userId) {
    final updatedUsers = state.typingUsers.where((u) => u != userId).toList();
    emit(
      state.copyWith(
        typingUsers: updatedUsers,
        isVisible: updatedUsers.isNotEmpty,
      ),
    );
  }

  void clearTypingUsers() {
    emit(TypingIndicatorState());
  }
}
