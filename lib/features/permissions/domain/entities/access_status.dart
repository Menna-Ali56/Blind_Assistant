enum AccessStatus {
  granted,
  denied,
  blocked;

  bool get isGranted => this == granted;

  bool get isBlocked => this == blocked;
}
