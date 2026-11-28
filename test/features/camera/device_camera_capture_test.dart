import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/core/errors/exceptions/exceptions.dart';
import 'package:baseer/features/camera/data/camera_error_codes.dart';
import 'package:baseer/features/camera/domain/entities/camera_status.dart';
import 'package:baseer/features/camera/domain/entities/captured_image.dart';
import 'package:flutter_test/flutter_test.dart';

import 'camera_test_support.dart';

Matcher cameraError(String code) =>
    throwsA(isA<AppCameraException>().having((e) => e.code, 'code', code));

void main() {
  late CameraHarness harness;

  setUp(() async {
    harness = CameraHarness();
    await harness.service.open();
  });

  test('capture returns the image bytes and time', () async {
    final image = await harness.service.capture();
    expect(
      image,
      CapturedImage(bytes: cameraTestBytes, capturedAt: cameraTestTime),
    );
    expect(harness.service.status, CameraStatus.ready);
  });

  test('capture before open throws not ready', () async {
    await harness.service.dispose();
    expect(harness.service.capture(), cameraError(CameraErrorCodes.notReady));
  });

  test('capture during capture throws and keeps the first', () async {
    harness.driver.gate = Completer<Uint8List>();
    final first = harness.service.capture();
    await expectLater(
      harness.service.capture(),
      cameraError(CameraErrorCodes.notReady),
    );
    harness.driver.gate!.complete(cameraTestBytes);
    expect((await first).bytes, cameraTestBytes);
  });

  test('empty capture throws empty capture error', () {
    harness.driver.bytes = Uint8List(0);
    expect(
      harness.service.capture(),
      cameraError(CameraErrorCodes.emptyCapture),
    );
  });

  test('capture error leaves the camera ready', () async {
    harness.driver.captureError = StateError('boom');
    await expectLater(
      harness.service.capture(),
      throwsA(isA<AppCameraException>()),
    );
    expect(harness.service.status, CameraStatus.ready);
  });
}
