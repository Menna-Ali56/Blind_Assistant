import '../errors/errors.dart';

class SafeStatePolicy {
  const SafeStatePolicy();

  bool requiresSafeState(ErrorReport report) =>
      report.severity == ErrorSeverity.critical ||
      (report.severity.priority >= ErrorSeverity.error.priority &&
          _isHardware(report.failure));

  bool _isHardware(Failure failure) =>
      failure is CameraFailure || failure is ModelFailure;
}
