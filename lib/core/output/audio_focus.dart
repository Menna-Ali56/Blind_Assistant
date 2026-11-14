abstract interface class AudioFocus {
  Future<void> acquire();

  Future<void> release();

  Stream<void> get interruptions;
}

class NoAudioFocus implements AudioFocus {
  const NoAudioFocus();

  @override
  Future<void> acquire() async {}

  @override
  Future<void> release() async {}

  @override
  Stream<void> get interruptions => const Stream<void>.empty();
}
