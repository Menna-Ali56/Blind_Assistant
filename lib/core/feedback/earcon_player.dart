import 'dart:typed_data';

import '../output/audio_focus.dart';
import 'cue_output.dart';
import 'earcon_catalog.dart';
import 'earcon_driver.dart';
import 'feedback_cue.dart';
import 'tone_wav.dart';

class EarconPlayer implements CueOutput {
  EarconPlayer({
    required this._driver,
    required this._focus,
    required this._isEnabled,
    this.onError,
  });

  final EarconDriver _driver;
  final AudioFocus _focus;
  final bool Function() _isEnabled;
  final void Function(Object error, StackTrace stackTrace)? onError;
  final Map<FeedbackCue, Uint8List> _wavs = {};

  @override
  Future<void> play(FeedbackCue cue) async {
    var focused = false;
    try {
      if (!_isEnabled()) return;
      final spec = EarconCatalog.of(cue);
      final wav = _wavs.putIfAbsent(cue, () => ToneWav.encode(spec));
      await _focus.acquire();
      focused = true;
      await _driver.play(wav, length: spec.total);
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    } finally {
      if (focused) await _guard(_focus.release);
    }
  }

  @override
  Future<void> cancel() => _guard(_driver.stop);

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    }
  }

  void _report(Object error, StackTrace stackTrace) {
    try {
      onError?.call(error, stackTrace);
    } catch (_) {}
  }
}
