import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../core/errors/errors.dart';

class FlutterTtsDataSource {
  FlutterTtsDataSource(this._flutterTts);

  final FlutterTts _flutterTts;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await _flutterTts.awaitSpeakCompletion(true);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _initialized = true;
    } on PlatformException catch (error) {
      throw SpeechException(
        message: 'Failed to initialize text to speech',
        code: 'tts_initialization_failed',
        cause: error,
      );
    }
  }

  Future<void> speak(String text, {required String languageCode}) async {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty) return;

    await initialize();

    try {
      await _flutterTts.setLanguage(languageCode);
      final result = await _flutterTts.speak(normalizedText);

      if (result != 1) {
        throw const SpeechException(
          message: 'Text to speech playback failed',
          code: 'tts_playback_failed',
        );
      }
    } on PlatformException catch (error) {
      throw SpeechException(
        message: 'Text to speech operation failed',
        code: 'tts_platform_error',
        cause: error,
      );
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } on PlatformException catch (error) {
      throw SpeechException(
        message: 'Failed to stop text to speech',
        code: 'tts_stop_failed',
        cause: error,
      );
    }
  }
}
