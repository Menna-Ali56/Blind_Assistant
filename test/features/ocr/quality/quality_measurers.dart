import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/features/ocr/data/quality/gray_image_decoder.dart';
import 'package:baseer/features/ocr/domain/quality/quality_calculator.dart';
import 'package:baseer/features/ocr/domain/quality/quality_measurer.dart';
import 'package:baseer/features/ocr/domain/quality/quality_metrics.dart';
import 'package:baseer/features/ocr/domain/quality/quality_thresholds.dart';

QualityThresholds seedWith({Duration? timeout, double? minSharpness}) =>
    QualityThresholds(
      longSide: QualityThresholds.seed.longSide,
      minSharpness: minSharpness ?? QualityThresholds.seed.minSharpness,
      minBrightness: QualityThresholds.seed.minBrightness,
      maxBrightness: QualityThresholds.seed.maxBrightness,
      timeout: timeout ?? QualityThresholds.seed.timeout,
    );

class CalculatorMeasurer implements QualityMeasurer {
  const CalculatorMeasurer();

  @override
  Future<QualityMetrics> measure(
    Uint8List bytes, {
    required int longSide,
  }) async => QualityCalculator.measure(
    GrayImageDecoder.decode(bytes, longSide: longSide),
  );
}

class ScriptedMeasurer implements QualityMeasurer {
  ScriptedMeasurer(this.pending);

  final List<Completer<QualityMetrics>> pending;
  int calls = 0;

  @override
  Future<QualityMetrics> measure(Uint8List bytes, {required int longSide}) =>
      pending[calls++].future;
}
