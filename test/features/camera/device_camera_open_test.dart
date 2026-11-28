import 'package:baseer/core/errors/exceptions/exceptions.dart';
import 'package:baseer/features/camera/domain/entities/camera_status.dart';
import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:flutter_test/flutter_test.dart';

import 'camera_test_support.dart';

void main() {
  late CameraHarness harness;

  setUp(() => harness = CameraHarness());

  test('open makes the camera ready', () async {
    await harness.service.open();
    expect(harness.service.status, CameraStatus.ready);
    expect(harness.driver.opens, 1);
  });

  test('open twice opens the driver once', () async {
    await harness.service.open();
    await harness.service.open();
    expect(harness.driver.opens, 1);
  });

  test('driver errors become camera exceptions', () async {
    harness.driver.openError = StateError('boom');
    await expectLater(
      harness.service.open(),
      throwsA(isA<AppCameraException>()),
    );
    expect(harness.service.status, CameraStatus.closed);
  });

  for (final blocked in [false, true]) {
    test('open without permission blocked $blocked', () async {
      final denied = CameraHarness(
        access: blocked ? AccessStatus.blocked : AccessStatus.denied,
      );
      await expectLater(
        denied.service.open(),
        throwsA(
          isA<PermissionException>().having(
            (e) => e.isPermanentlyDenied,
            'blocked',
            blocked,
          ),
        ),
      );
      expect(denied.driver.opens, 0);
    });
  }
}
