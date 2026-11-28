import 'dart:typed_data';

import 'quality_metrics.dart';

abstract interface class QualityMeasurer {
  Future<QualityMetrics> measure(Uint8List bytes, {required int longSide});
}
