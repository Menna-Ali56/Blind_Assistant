enum MicrophoneStatus {
  granted,
  denied,

  blocked;

  bool get isGranted => this == granted;
}

abstract interface class MicrophoneAccess {
  Future<MicrophoneStatus> status();
}
