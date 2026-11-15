import 'output_priority.dart';

enum OutputHaptic { none, light, heavy }

abstract interface class OutputChannel {
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  });

  Future<void> stop();

  Future<void> haptic(OutputHaptic kind);
}

abstract interface class SpeechChannel implements OutputChannel {}

class SilentOutputChannel implements OutputChannel {
  const SilentOutputChannel();

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  }) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> haptic(OutputHaptic kind) async {}
}
