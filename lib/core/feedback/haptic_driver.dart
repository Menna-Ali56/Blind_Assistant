abstract interface class HapticDriver {
  Future<bool> get isAvailable;

  Future<void> play({
    required List<int> timings,
    required List<int> amplitudes,
  });

  Future<void> cancel();
}
