import 'package:baseer/features/camera_capture/presentation/cubit/camera_stage.dart';
import 'package:baseer/features/camera_capture/presentation/texts/camera_texts_ar.dart';
import 'package:baseer/features/camera_capture/presentation/texts/camera_texts_en.dart';
import 'package:baseer/features/camera_capture/presentation/texts/camera_texts_lookup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final stage in CameraStage.values) {
    test('${stage.name} has a different message in each language', () {
      final english = englishCameraTexts.spoken(stage);
      final arabic = arabicCameraTexts.spoken(stage);

      expect(english, isNotEmpty);
      expect(arabic, isNotEmpty);
      expect(arabic, isNot(english));
    });
  }

  test('lookup picks arabic only for arabic codes', () {
    expect(cameraTextsFor('ar-EG'), arabicCameraTexts);
    expect(cameraTextsFor('en-US'), englishCameraTexts);
  });
}
