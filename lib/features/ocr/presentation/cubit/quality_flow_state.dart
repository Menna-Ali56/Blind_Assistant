import 'package:equatable/equatable.dart';

import '../../../camera/domain/entities/captured_image.dart';
import '../../domain/quality/quality_verdict.dart';

enum QualityFlowStatus { idle, checking, accepted, rejected, failed }

class QualityFlowState extends Equatable {
  const QualityFlowState({
    this.status = QualityFlowStatus.idle,
    this.image,
    this.verdict,
  });

  final QualityFlowStatus status;
  final CapturedImage? image;
  final QualityVerdict? verdict;

  bool get canRetake =>
      status == QualityFlowStatus.rejected ||
      status == QualityFlowStatus.failed;

  QualityFlowState to(
    QualityFlowStatus next,
    CapturedImage source, [
    QualityVerdict? result,
  ]) => QualityFlowState(status: next, image: source, verdict: result);

  @override
  List<Object?> get props => [status, image, verdict];
}
