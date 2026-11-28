import 'package:baseer/features/camera/domain/entities/captured_image.dart';
import 'package:flutter_test/flutter_test.dart';

import 'camera_test_support.dart';

void main() {
  test('size matches the byte length', () {
    final image = CapturedImage(
      bytes: cameraTestBytes,
      capturedAt: cameraTestTime,
    );
    expect(image.sizeBytes, cameraTestBytes.length);
  });

  test('images with the same data are equal', () {
    CapturedImage build() =>
        CapturedImage(bytes: cameraTestBytes, capturedAt: cameraTestTime);
    expect(build(), build());
  });
}
