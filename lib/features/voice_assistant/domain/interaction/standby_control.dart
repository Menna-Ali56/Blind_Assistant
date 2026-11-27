/// Starts and stops the wake word listening that keeps the microphone while
/// the assistant is idle.
abstract interface class StandbyControl {
  Future<void> start();

  Future<void> stop();
}
