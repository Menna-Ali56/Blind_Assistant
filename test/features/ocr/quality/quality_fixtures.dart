import 'dart:typed_data';

import 'package:baseer/features/ocr/domain/quality/gray_image.dart';
import 'package:baseer/features/ocr/domain/quality/quality_issue.dart';
import 'package:image/image.dart' as img;

const int fixtureWidth = 160;
const int fixtureHeight = 120;
const int stripeWidth = 4;

class QualityFixture {
  const QualityFixture(
    this.name,
    this.low,
    this.high,
    this.expected, {
    this.blurWindow = 1,
  });

  final String name;
  final int low;
  final int high;
  final QualityIssue? expected;
  final int blurWindow;
}

const List<QualityFixture> qualityFixtures = [
  QualityFixture('sharp', 40, 215, null),
  QualityFixture(
    'blurry',
    40,
    215,
    QualityIssue.blurry,
    blurWindow: stripeWidth * 2,
  ),
  QualityFixture('dark', 0, 40, QualityIssue.tooDark),
  QualityFixture('bright', 150, 230, null),
  QualityFixture('overexposed', 245, 255, QualityIssue.tooBright),
];

Uint8List stripeLuma(
  QualityFixture fixture, {
  int width = fixtureWidth,
  int height = fixtureHeight,
}) {
  final luma = Uint8List(width * height);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final even = (x ~/ stripeWidth).isEven;
      luma[y * width + x] = even ? fixture.high : fixture.low;
    }
  }
  return _blurRows(luma, width, fixture.blurWindow);
}

Uint8List _blurRows(Uint8List source, int width, int window) {
  final out = Uint8List(source.length);
  for (var i = 0; i < source.length; i++) {
    final row = i - i % width;
    var sum = 0;
    for (var k = 0; k < window; k++) {
      sum += source[row + (i % width + k) % width];
    }
    out[i] = sum ~/ window;
  }
  return out;
}

GrayImage grayOf(QualityFixture fixture) => GrayImage(
  width: fixtureWidth,
  height: fixtureHeight,
  luma: stripeLuma(fixture),
);

Uint8List pngOf(
  QualityFixture fixture, {
  int width = fixtureWidth,
  int height = fixtureHeight,
}) {
  final luma = stripeLuma(fixture, width: width, height: height);
  final image = img.Image(width: width, height: height);
  for (var i = 0; i < luma.length; i++) {
    image.setPixelRgb(i % width, i ~/ width, luma[i], luma[i], luma[i]);
  }
  return img.encodePng(image);
}
