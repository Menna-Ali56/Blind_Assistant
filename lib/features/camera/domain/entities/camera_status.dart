enum CameraStatus {
  closed,
  opening,
  ready,
  capturing,
  paused;

  bool get isReady => this == ready;

  bool get isActive => this == opening || this == ready || this == capturing;
}
