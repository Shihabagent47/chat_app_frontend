import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/initiate_call.dart';
import '../../domain/usecases/answer_call.dart';
import '../../domain/usecases/end_call.dart';
import '../../domain/usecases/toggle_camera.dart';
import '../../domain/repositories/video_call_repository.dart';
import 'video_call_event.dart';
import 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final InitiateCall initiateCall;
  final AnswerCall answerCall;
  final EndCall endCall;
  final ToggleCamera toggleCamera;
  final VideoCallRepository repository;

  VideoCallBloc({
    required this.initiateCall,
    required this.answerCall,
    required this.endCall,
    required this.toggleCamera,
    required this.repository,
  }) : super(VideoCallInitial()) {
    on<InitiateCallEvent>(_onInitiateCall);
    on<AnswerCallEvent>(_onAnswerCall);
    on<EndCallEvent>(_onEndCall);
    on<ToggleCameraEvent>(_onToggleCamera);
    on<ToggleMicrophoneEvent>(_onToggleMicrophone);
    on<SwitchCameraEvent>(_onSwitchCamera);
    on<CallSessionUpdatedEvent>(_onCallSessionUpdated);
  }

  Future<void> _onInitiateCall(
    InitiateCallEvent event,
    Emitter<VideoCallState> emit,
  ) async {
    try {
      emit(VideoCallLoading());

      final callSession = await initiateCall(
        receiverId: event.receiverId,
        type: event.type,
      );

      emit(
        VideoCallInProgress(
          callSession: callSession,
          participants: callSession.participants,
        ),
      );

      // Listen for call updates
      await emit.forEach(
        repository.watchCallSession(callSession.id),
        onData:
            (callSession) => VideoCallInProgress(
              callSession: callSession,
              participants: callSession.participants,
            ),
      );
    } catch (e) {
      emit(VideoCallError(e.toString()));
    }
  }

  Future<void> _onAnswerCall(
    AnswerCallEvent event,
    Emitter<VideoCallState> emit,
  ) async {
    try {
      emit(VideoCallLoading());

      final callSession = await answerCall(
        callId: event.callId,
        accept: event.accept,
      );

      if (event.accept) {
        emit(
          VideoCallInProgress(
            callSession: callSession,
            participants: callSession.participants,
          ),
        );
      } else {
        emit(VideoCallEnded(callSession));
      }
    } catch (e) {
      emit(VideoCallError(e.toString()));
    }
  }

  Future<void> _onEndCall(
    EndCallEvent event,
    Emitter<VideoCallState> emit,
  ) async {
    try {
      await endCall(event.callId);

      if (state is VideoCallInProgress) {
        final currentState = state as VideoCallInProgress;
        emit(VideoCallEnded(currentState.callSession));
      }
    } catch (e) {
      emit(VideoCallError(e.toString()));
    }
  }

  Future<void> _onToggleCamera(
    ToggleCameraEvent event,
    Emitter<VideoCallState> emit,
  ) async {
    if (state is VideoCallInProgress) {
      final currentState = state as VideoCallInProgress;
      await toggleCamera();

      emit(currentState.copyWith(isCameraOn: !currentState.isCameraOn));
    }
  }

  Future<void> _onToggleMicrophone(
    ToggleMicrophoneEvent event,
    Emitter<VideoCallState> emit,
  ) async {
    if (state is VideoCallInProgress) {
      final currentState = state as VideoCallInProgress;
      await repository.toggleMicrophone();

      emit(currentState.copyWith(isMicrophoneOn: !currentState.isMicrophoneOn));
    }
  }

  Future<void> _onSwitchCamera(
    SwitchCameraEvent event,
    Emitter<VideoCallState> emit,
  ) async {
    await repository.switchCamera();
  }

  void _onCallSessionUpdated(
    CallSessionUpdatedEvent event,
    Emitter<VideoCallState> emit,
  ) {
    if (state is VideoCallInProgress) {
      final currentState = state as VideoCallInProgress;
      emit(
        currentState.copyWith(
          callSession: event.callSession,
          participants: event.callSession.participants,
        ),
      );
    }
  }
}
