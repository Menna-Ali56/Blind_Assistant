enum MicrophoneStatus {
  granted,
  denied,

  /// Only the phone settings can fix it.
  blocked;

  bool get isGranted => this == granted;
}

/// What the audio code needs to know about the microphone permission.
/// The permissions feature implements it, so `core` stays independent.
abstract interface class MicrophoneAccess {
  Future<MicrophoneStatus> status();
}
