import 'package:get_it/get_it.dart';

import '../../core/audio/microphone_access.dart';
import '../../core/audio/recorder_backend.dart';
import '../../core/di/di_module.dart';
import '../permissions/data/repositories/permission_microphone_access.dart';
import '../permissions/domain/repositories/permission_repository.dart';
import 'data/audio_frame_source.dart';
import 'data/frame_source_recorder_backend.dart';

/// Connects the core audio capture to this feature's microphone and to the
/// permissions feature.
class VoiceCaptureModule implements DiModule {
  const VoiceCaptureModule();

  @override
  void register(GetIt locator) {
    locator
      ..registerLazySingleton<RecorderBackend>(
        () => FrameSourceRecorderBackend(locator<AudioFrameSource>()),
      )
      ..registerLazySingleton<MicrophoneAccess>(
        () => PermissionMicrophoneAccess(locator<PermissionRepository>()),
      );
  }
}
