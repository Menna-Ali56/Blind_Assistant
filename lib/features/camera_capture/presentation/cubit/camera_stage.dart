enum CameraStage {
  opening,
  ready,
  capturing,
  review,
  accepted,
  openFailed,
  captureFailed;

  bool get isFailure => this == openFailed || this == captureFailed;
}
