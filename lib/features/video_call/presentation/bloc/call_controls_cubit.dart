import 'package:flutter_bloc/flutter_bloc.dart';

class CallControlsState {
  final bool isCameraOn;
  final bool isMicrophoneOn;
  final bool isSpeakerOn;
  final bool isFullScreen;

  const CallControlsState({
    this.isCameraOn = true,
    this.isMicrophoneOn = true,
    this.isSpeakerOn = false,
    this.isFullScreen = false,
  });

  CallControlsState copyWith({
    bool? isCameraOn,
    bool? isMicrophoneOn,
    bool? isSpeakerOn,
    bool? isFullScreen,
  }) {
    return CallControlsState(
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isMicrophoneOn: isMicrophoneOn ?? this.isMicrophoneOn,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isFullScreen: isFullScreen ?? this.isFullScreen,
    );
  }
}

class CallControlsCubit extends Cubit<CallControlsState> {
  CallControlsCubit() : super(const CallControlsState());

  void toggleCamera() {
    emit(state.copyWith(isCameraOn: !state.isCameraOn));
  }

  void toggleMicrophone() {
    emit(state.copyWith(isMicrophoneOn: !state.isMicrophoneOn));
  }

  void toggleSpeaker() {
    emit(state.copyWith(isSpeakerOn: !state.isSpeakerOn));
  }

  void toggleFullScreen() {
    emit(state.copyWith(isFullScreen: !state.isFullScreen));
  }
}
