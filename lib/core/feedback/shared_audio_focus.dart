import '../output/audio_focus.dart';

class SharedAudioFocus implements AudioFocus {
  SharedAudioFocus(this._inner);

  final AudioFocus _inner;
  int _holders = 0;

  @override
  Future<void> acquire() async {
    _holders++;
    if (_holders > 1) return;
    try {
      await _inner.acquire();
    } catch (_) {
      _holders--;
      rethrow;
    }
  }

  @override
  Future<void> release() async {
    if (_holders == 0) return;
    _holders--;
    if (_holders == 0) await _inner.release();
  }

  @override
  Stream<void> get interruptions => _inner.interruptions;
}
