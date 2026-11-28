import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/features/camera/domain/entities/captured_image.dart';
import 'package:baseer/features/ocr/domain/quality/quality_gate.dart';
import 'package:baseer/features/ocr/domain/quality/quality_issue.dart';
import 'package:baseer/features/ocr/domain/quality/quality_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'quality_fixtures.dart';
import 'quality_measurers.dart';

void main() {
  const gate = QualityGate(CalculatorMeasurer());

  for (final fixture in qualityFixtures) {
    test('${fixture.name} image gives the expected verdict', () async {
      final image = CapturedImage(
        bytes: pngOf(fixture),
        capturedAt: DateTime(2026),
      );
      final verdict = await gate.check(image);
      expect(verdict.issue, fixture.expected);
      expect(verdict.wasChecked, isTrue);
    });
  }

  test('bytes that are not an image give an unreadable verdict', () async {
    final image = CapturedImage(
      bytes: Uint8List.fromList([1, 2, 3]),
      capturedAt: DateTime(2026),
    );
    final verdict = await gate.check(image);
    expect(verdict.issue, QualityIssue.unreadable);
  });

  test('a stuck check ends at the timeout and does not block', () async {
    final slow = QualityGate(
      ScriptedMeasurer([Completer<QualityMetrics>()]),
      thresholds: seedWith(timeout: const Duration(milliseconds: 20)),
    );
    final watch = Stopwatch()..start();
    final verdict = await slow.check(
      CapturedImage(bytes: Uint8List(0), capturedAt: DateTime(2026)),
    );
    expect(verdict.isAcceptable, isTrue);
    expect(verdict.wasChecked, isFalse);
    expect(watch.elapsed, lessThan(const Duration(seconds: 1)));
  });

  test('thresholds can be replaced without touching the engine', () async {
    final strict = QualityGate(
      const CalculatorMeasurer(),
      thresholds: seedWith(minSharpness: 1e9),
    );
    final image = CapturedImage(
      bytes: pngOf(qualityFixtures.first),
      capturedAt: DateTime(2026),
    );
    expect((await strict.check(image)).issue, QualityIssue.blurry);
  });
}
