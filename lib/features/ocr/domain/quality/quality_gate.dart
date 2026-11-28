import 'dart:async';

import '../../../camera/domain/entities/captured_image.dart';
import 'quality_issue.dart';
import 'quality_measurer.dart';
import 'quality_metrics.dart';
import 'quality_thresholds.dart';
import 'quality_verdict.dart';

class QualityGate {
  const QualityGate(this._measurer, {this.thresholds = QualityThresholds.seed});

  final QualityMeasurer _measurer;
  final QualityThresholds thresholds;

  /// A slow check never blocks the user and gives an unchecked verdict
  Future<QualityVerdict> check(CapturedImage image) async {
    try {
      final metrics = await _measurer
          .measure(image.bytes, longSide: thresholds.longSide)
          .timeout(thresholds.timeout);
      return QualityVerdict(issue: _issueOf(metrics), metrics: metrics);
    } on TimeoutException {
      return const QualityVerdict.unchecked();
    } on FormatException {
      return const QualityVerdict(issue: QualityIssue.unreadable);
    }
  }

  // light is judged first because a dark photo also looks flat
  QualityIssue? _issueOf(QualityMetrics metrics) {
    if (metrics.brightness < thresholds.minBrightness) {
      return QualityIssue.tooDark;
    }
    if (metrics.brightness > thresholds.maxBrightness) {
      return QualityIssue.tooBright;
    }
    if (metrics.sharpness < thresholds.minSharpness) {
      return QualityIssue.blurry;
    }
    return null;
  }
}
