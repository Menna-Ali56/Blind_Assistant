import '../accessibility/screen_reader_status.dart';
import 'output_channel.dart';
import 'output_priority.dart';

class ScreenReaderAwareChannel implements OutputChannel {
  const ScreenReaderAwareChannel({
    required this._speech,
    required this._announcements,
    required this._status,
  });

  final OutputChannel _speech;
  final OutputChannel _announcements;
  final ScreenReaderStatus _status;

  OutputChannel _routeOf(OutputPriority priority) =>
      _status.isActive && !priority.interrupts(OutputPriority.normal)
      ? _announcements
      : _speech;

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  }) => _routeOf(
    priority,
  ).speak(text, languageCode: languageCode, priority: priority);

  @override
  Future<void> stop() async {
    await _speech.stop();
    await _announcements.stop();
  }

  @override
  Future<void> haptic(OutputHaptic kind) => _speech.haptic(kind);
}
