import '../repositories/video_call_repository.dart';

class ToggleCamera {
  final VideoCallRepository repository;

  ToggleCamera(this.repository);

  Future<void> call() async {
    await repository.toggleCamera();
  }
}
