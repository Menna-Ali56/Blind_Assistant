import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';

import '../../core/di/di_module.dart';
import '../../core/output/output_channel.dart';
import 'data/channels/tts_speech_channel.dart';
import 'data/data_sources/flutter_tts_data_source.dart';

/// Registers the platform TTS implementation used by OutputCoordinator.
class TextToSpeechModule implements DiModule {
  const TextToSpeechModule();

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<FlutterTts>()) {
      locator.registerLazySingleton<FlutterTts>(FlutterTts.new);
    }

    if (!locator.isRegistered<FlutterTtsDataSource>()) {
      locator.registerLazySingleton<FlutterTtsDataSource>(
        () => FlutterTtsDataSource(locator<FlutterTts>()),
      );
    }

    if (!locator.isRegistered<SpeechChannel>()) {
      locator.registerLazySingleton<SpeechChannel>(
        () => TtsSpeechChannel(locator<FlutterTtsDataSource>()),
      );
    }
  }
}
