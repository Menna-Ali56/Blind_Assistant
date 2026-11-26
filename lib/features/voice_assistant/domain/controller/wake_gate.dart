import '../../data/catalog/command_keywords.dart';
import '../catalog/spotter_limits.dart';

class WakeGate {
  WakeGate({required this._now, this._window = SpotterLimits.wakeWindow});

  final DateTime Function() _now;
  final Duration _window;
  DateTime? _until;

  bool get isOpen {
    final until = _until;
    return until != null && _now().isBefore(until);
  }

  /// Consumes the wake phrase locally (never dispatched to [CommandSink]) and
  /// gates command ids until [open] has been called within [_window].
  bool admit(String id, {required bool enabled}) {
    if (id == CommandKeywords.wakeId) {
      if (enabled) open();
      return false;
    }
    if (!enabled) return true;
    if (!isOpen) return false;
    close();
    return true;
  }

  void open() => _until = _now().add(_window);

  void close() => _until = null;
}
