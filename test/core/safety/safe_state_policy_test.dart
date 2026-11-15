import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/safety/safety.dart';
import 'package:flutter_test/flutter_test.dart';

ErrorReport _report(Failure failure, ErrorSeverity severity) => ErrorReport(
  failure: failure,
  severity: severity,
  source: 'test',
  at: DateTime(2026),
);

void main() {
  const policy = SafeStatePolicy();

  test('critical severity enters safe state', () {
    expect(
      policy.requiresSafeState(
        _report(const UnknownFailure(), ErrorSeverity.critical),
      ),
      isTrue,
    );
  });

  test('warning severity does not enter safe state', () {
    expect(
      policy.requiresSafeState(
        _report(const CameraFailure(), ErrorSeverity.warning),
      ),
      isFalse,
    );
  });

  test('hardware failure at error severity enters safe state', () {
    expect(
      policy.requiresSafeState(
        _report(const CameraFailure(), ErrorSeverity.error),
      ),
      isTrue,
    );
    expect(
      policy.requiresSafeState(
        _report(const ModelFailure(), ErrorSeverity.error),
      ),
      isTrue,
    );
  });

  test('CancelledFailure does not enter safe state', () {
    expect(
      policy.requiresSafeState(
        _report(const CancelledFailure(), ErrorSeverity.info),
      ),
      isFalse,
    );
  });
}
