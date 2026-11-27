import 'dart:math' as math;
import 'dart:typed_data';

import 'audio_format.dart';

enum SpeechSignal { none, speechStarted, speechEnded, noSpeech }

/// Finds where speech starts and ends by looking at how loud the audio is.
/// It counts audio time, not clock time, so it behaves the same in tests.
class SpeechDetector {
  SpeechDetector({
    this.format = AudioFormat.speech,
    this.threshold = defaultThreshold,
    this.minSpeech = defaultMinSpeech,
    this.silenceToEnd = defaultSilenceToEnd,
    this.noSpeechTimeout = defaultNoSpeechTimeout,
  });

  /// Loudness (0 to 1) that counts as sound.
  static const double defaultThreshold = 0.02;

  /// Shorter sounds (a click) are not speech.
  static const Duration defaultMinSpeech = Duration(milliseconds: 150);

  /// Slow speakers need a long pause before we decide they are done.
  static const Duration defaultSilenceToEnd = Duration(milliseconds: 1200);
  static const Duration defaultNoSpeechTimeout = Duration(seconds: 6);

  static const double _fullScale = 32768;

  final AudioFormat format;
  final double threshold;
  final Duration minSpeech;
  final Duration silenceToEnd;
  final Duration noSpeechTimeout;

  Duration _elapsed = Duration.zero;
  Duration _loud = Duration.zero;
  Duration _silence = Duration.zero;
  bool _speaking = false;
  bool _done = false;

  bool get hasSpeech => _speaking;

  SpeechSignal feed(Uint8List chunk) {
    if (_done) return SpeechSignal.none;
    final length = format.durationOf(chunk.lengthInBytes);
    _elapsed += length;
    final isLoud = rmsOf(chunk) >= threshold;

    if (!_speaking) {
      _loud = isLoud ? _loud + length : Duration.zero;
      if (_loud >= minSpeech) {
        _speaking = true;
        _silence = Duration.zero;
        return SpeechSignal.speechStarted;
      }
      if (_elapsed >= noSpeechTimeout) {
        _done = true;
        return SpeechSignal.noSpeech;
      }
      return SpeechSignal.none;
    }

    _silence = isLoud ? Duration.zero : _silence + length;
    if (_silence >= silenceToEnd) {
      _done = true;
      return SpeechSignal.speechEnded;
    }
    return SpeechSignal.none;
  }

  void reset() {
    _elapsed = Duration.zero;
    _loud = Duration.zero;
    _silence = Duration.zero;
    _speaking = false;
    _done = false;
  }

  /// Loudness of 16-bit little endian PCM, from 0 (silence) to 1 (full scale).
  static double rmsOf(Uint8List pcm) {
    final samples = pcm.lengthInBytes ~/ AudioFormat.bytesPerSample;
    if (samples == 0) return 0;
    final data = ByteData.sublistView(pcm);
    var sum = 0.0;
    for (var i = 0; i < samples; i++) {
      final value = data.getInt16(
        i * AudioFormat.bytesPerSample,
        Endian.little,
      );
      final normalized = value / _fullScale;
      sum += normalized * normalized;
    }
    return math.sqrt(sum / samples);
  }
}
