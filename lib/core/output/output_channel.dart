enum OutputHaptic { none, light, heavy }

/// The device side of output: speech and vibration.
/// The real text to speech feature implements this.
abstract interface class OutputChannel {
  /// Completes when the speech has finished.
  Future<void> speak(String text, {required String languageCode});

  Future<void> stop();

  Future<void> haptic(OutputHaptic kind);
}

/// Default channel that does nothing, until a real one is registered.
class SilentOutputChannel implements OutputChannel {
  const SilentOutputChannel();

  @override
  Future<void> speak(String text, {required String languageCode}) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> haptic(OutputHaptic kind) async {}
}
