import 'package:get_it/get_it.dart';

import '../di/di_module.dart';
import '../errors/errors.dart';
import '../output/audio_focus.dart';
import 'audio_capture.dart';
import 'microphone_access.dart';
import 'pcm_audio_capture.dart';
import 'recorder_backend.dart';
import 'utterance_recorder.dart';

/// Needs a [RecorderBackend] and a [MicrophoneAccess]. The voice assistant
/// feature registers both, so there is only one real microphone owner.
class AudioModule implements DiModule {
  const AudioModule();

  @override
  void register(GetIt locator) {
    locator
      ..registerLazySingleton<AudioCapture>(
        () => PcmAudioCapture(
          backend: locator<RecorderBackend>(),
          access: locator<MicrophoneAccess>(),
          errorHandler: locator<ErrorHandler>(),
          interruptions: locator<AudioFocus>().interruptions,
        ),
        dispose: (capture) => capture.dispose(),
      )
      ..registerFactory<UtteranceRecorder>(
        () => UtteranceRecorder(locator<AudioCapture>()),
      );
  }
}
