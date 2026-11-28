import '../../../../core/errors/failures/failure.dart';
import '../../../../core/errors/presentation/error_presentation.dart';
import '../../../../core/output/output_message.dart';
import '../../../../core/output/output_coordinator.dart';
import '../../domain/quality/quality_issue.dart';
import '../policy/quality_flow_policy.dart';
import 'quality_advice.dart';

class QualityAnnouncer {
  QualityAnnouncer({
    required this._output,
    required this._languageCode,
    this._advice = const QualityAdvice(),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final OutputCoordinator _output;
  final String Function() _languageCode;
  final QualityAdvice _advice;
  final DateTime Function() _now;
  QualityIssue? _lastIssue;
  DateTime? _lastAt;

  void announce(QualityIssue issue) {
    final now = _now();
    if (_isRepeat(issue, now)) return;
    _lastIssue = issue;
    _lastAt = now;
    _say(_advice.spokenFor(issue, languageCode: _languageCode()));
  }

  void announceFailure(Failure failure) {
    final presentation = ErrorPresentation.from(
      failure,
      languageCode: _languageCode(),
    );
    if (!presentation.isSilent) _say(presentation.spoken);
  }

  void cancel() {
    _lastIssue = null;
    _lastAt = null;
    _output.cancelOwner(QualityFlowPolicy.ownerId);
  }

  bool _isRepeat(QualityIssue issue, DateTime now) {
    final lastAt = _lastAt;
    return issue == _lastIssue &&
        lastAt != null &&
        now.difference(lastAt) < QualityFlowPolicy.repeatWindow;
  }

  void _say(String text) => _output.submit(
    OutputMessage(
      text: text,
      languageCode: _languageCode(),
      priority: QualityFlowPolicy.priority,
      haptic: QualityFlowPolicy.haptic,
      key: QualityFlowPolicy.messageKey,
      ownerId: QualityFlowPolicy.ownerId,
    ),
  );
}
