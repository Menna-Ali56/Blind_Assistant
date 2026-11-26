import 'cue_output.dart';
import 'feedback_cue.dart';
import 'haptic_catalog.dart';
import 'haptic_driver.dart';
import 'haptic_intensity.dart';
import 'haptic_spec.dart';

bool _always() => true;

HapticIntensity _defaultIntensity() => HapticIntensity.medium;

class HapticPlayer implements CueOutput {
  HapticPlayer({
    required this._driver,
    this._catalog = hapticCatalog,
    this._isEnabled = _always,
    this._intensity = _defaultIntensity,
    this.onError,
  });

  final HapticDriver _driver;
  final Map<FeedbackCue, HapticSpec> _catalog;
  final bool Function() _isEnabled;
  final HapticIntensity Function() _intensity;

  final void Function(Object error, StackTrace stackTrace)? onError;

  bool? _available;

  @override
  Future<void> play(FeedbackCue cue) async {
    final spec = _catalog[cue];
    if (spec == null || !_isEnabled()) return;
    await _safe(() async {
      if (!await _checkAvailable()) return;
      await _driver.play(
        timings: spec.timings,
        amplitudes: spec.amplitudes(_intensity()),
      );
    });
  }

  @override
  Future<void> cancel() => _safe(_driver.cancel);

  Future<bool> _checkAvailable() async =>
      _available ??= await _driver.isAvailable;

  Future<void> _safe(Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stackTrace) {
      try {
        onError?.call(error, stackTrace);
      } catch (_) {}
    }
  }
}
