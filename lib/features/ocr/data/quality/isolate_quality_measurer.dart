import 'dart:isolate';
import 'dart:typed_data';

import '../../domain/quality/quality_calculator.dart';
import '../../domain/quality/quality_measurer.dart';
import '../../domain/quality/quality_metrics.dart';
import 'gray_image_decoder.dart';

class IsolateQualityMeasurer implements QualityMeasurer {
  const IsolateQualityMeasurer();

  @override
  Future<QualityMetrics> measure(Uint8List bytes, {required int longSide}) =>
      Isolate.run(
        () => QualityCalculator.measure(
          GrayImageDecoder.decode(bytes, longSide: longSide),
        ),
      );
}
