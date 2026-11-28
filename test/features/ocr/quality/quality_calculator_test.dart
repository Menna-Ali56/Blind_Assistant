import 'dart:typed_data';

import 'package:baseer/features/ocr/domain/quality/gray_image.dart';
import 'package:baseer/features/ocr/domain/quality/quality_calculator.dart';
import 'package:baseer/features/ocr/domain/quality/quality_thresholds.dart';
import 'package:flutter_test/flutter_test.dart';

import 'quality_fixtures.dart';

void main() {
  const seed = QualityThresholds.seed;
  final byName = {for (final f in qualityFixtures) f.name: f};

  test('sharp stripes pass the sharpness limit', () {
    final metrics = QualityCalculator.measure(grayOf(byName['sharp']!));
    expect(metrics.sharpness, greaterThan(seed.minSharpness));
  });

  test('blurred stripes fall under the sharpness limit', () {
    final metrics = QualityCalculator.measure(grayOf(byName['blurry']!));
    expect(metrics.sharpness, lessThan(seed.minSharpness));
  });

  test('dark and overexposed images miss the brightness range', () {
    final dark = QualityCalculator.measure(grayOf(byName['dark']!));
    final washed = QualityCalculator.measure(grayOf(byName['overexposed']!));
    expect(dark.brightness, lessThan(seed.minBrightness));
    expect(washed.brightness, greaterThan(seed.maxBrightness));
  });

  test('a well lit image stays inside the brightness range', () {
    final metrics = QualityCalculator.measure(grayOf(byName['bright']!));
    expect(
      metrics.brightness,
      inInclusiveRange(seed.minBrightness, seed.maxBrightness),
    );
  });

  test('images too small for the kernel report zero sharpness', () {
    final tiny = GrayImage(width: 2, height: 2, luma: Uint8List(4));
    expect(QualityCalculator.measure(tiny).sharpness, 0);
  });

  test('an empty image reports zero brightness', () {
    final empty = GrayImage(width: 0, height: 0, luma: Uint8List(0));
    expect(QualityCalculator.measure(empty).brightness, 0);
  });
}
