import 'package:baseer/core/errors/exceptions/exceptions.dart';
import 'package:baseer/core/errors/failures/failures.dart';
import 'package:baseer/core/errors/mappers/exception_to_failure_mapper.dart';
import 'package:baseer/features/camera/data/camera_error_mapper.dart';
import 'package:camera/camera.dart' as plugin;
import 'package:flutter_test/flutter_test.dart';

const _failureMapper = ExceptionToFailureMapper();
const _blockedCodes = [
  'CameraAccessDeniedWithoutPrompt',
  'CameraAccessRestricted',
];

Failure _failureFor(String code) => _failureMapper.map(
  CameraErrorMapper.map(plugin.CameraException(code, 'details')),
);

void main() {
  test('denied code becomes a recoverable permission failure', () {
    final failure = _failureFor('CameraAccessDenied');
    expect(failure, isA<PermissionFailure>());
    expect((failure as PermissionFailure).isPermanentlyDenied, isFalse);
  });

  for (final code in _blockedCodes) {
    test('$code becomes a blocked permission failure', () {
      final failure = _failureFor(code) as PermissionFailure;
      expect(failure.isPermanentlyDenied, isTrue);
    });
  }

  test('other plugin codes become the camera failure', () {
    expect(_failureFor('cameraInUse'), isA<CameraFailure>());
  });

  test('unknown errors become the camera failure', () {
    final mapped = CameraErrorMapper.map(StateError('boom'));
    expect(mapped, isA<AppCameraException>());
    expect(_failureMapper.map(mapped), const CameraFailure());
  });

  test('app exceptions pass through unchanged', () {
    const original = AppCameraException(code: 'custom');
    expect(CameraErrorMapper.map(original), same(original));
  });

  test('guard maps thrown errors', () {
    expect(
      CameraErrorMapper.guard<void>(() async => throw StateError('boom')),
      throwsA(isA<AppCameraException>()),
    );
  });
}
