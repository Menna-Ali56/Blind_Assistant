import 'package:equatable/equatable.dart';

import 'quality_issue.dart';
import 'quality_metrics.dart';

class QualityVerdict extends Equatable {
  const QualityVerdict({this.issue, this.metrics});

  const QualityVerdict.unchecked() : this();

  final QualityIssue? issue;
  final QualityMetrics? metrics;

  bool get isAcceptable => issue == null;
  bool get wasChecked => metrics != null;

  @override
  List<Object?> get props => [issue, metrics];
}
