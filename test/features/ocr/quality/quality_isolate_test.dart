import 'package:baseer/features/camera/domain/entities/captured_image.dart';
import 'package:baseer/features/ocr/data/quality/gray_image_decoder.dart';
import 'package:baseer/features/ocr/data/quality/isolate_quality_measurer.dart';
import 'package:baseer/features/ocr/domain/quality/quality_gate.dart';
import 'package:flutter_test/flutter_test.dart';

import 'quality_fixtures.dart';
import 'quality_measurers.dart';

void main() {
  const longSide = 640;
  const bigWidth = 800;
  const bigHeight = 600;

  for (final fixture in qualityFixtures) {
    test('${fixture.name} image is judged in a background isolate', () async {
      final gate = QualityGate(
        const IsolateQualityMeasurer(),
        thresholds: seedWith(timeout: const Duration(seconds: 20)),
      );
      final verdict = await gate.check(
        CapturedImage(bytes: pngOf(fixture), capturedAt: DateTime(2026)),
      );
      expect(verdict.issue, fixture.expected);
    });
  }

  test('a wide image is scaled so the long side matches the config', () {
    final bytes = pngOf(
      qualityFixtures.first,
      width: bigWidth,
      height: bigHeight,
    );
    final gray = GrayImageDecoder.decode(bytes, longSide: longSide);
    expect(gray.width, longSide);
    expect(gray.height, bigHeight * longSide ~/ bigWidth);
  });

  test('a tall image is scaled on its height', () {
    final bytes = pngOf(
      qualityFixtures.first,
      width: bigHeight,
      height: bigWidth,
    );
    final gray = GrayImageDecoder.decode(bytes, longSide: longSide);
    expect(gray.height, longSide);
  });
}
