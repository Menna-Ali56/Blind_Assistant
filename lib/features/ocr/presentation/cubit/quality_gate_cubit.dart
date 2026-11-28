import '../../../../core/cubit/base_cubit.dart';
import '../../../../core/errors/failures/cancelled_failure.dart';
import '../../../../core/errors/failures/failure.dart';
import '../../../../core/tasks/task_controller.dart';
import '../../../../core/tasks/task_handle.dart';
import '../../../camera/domain/entities/captured_image.dart';
import '../../domain/quality/quality_gate.dart';
import '../../domain/quality/quality_verdict.dart';
import '../advice/quality_announcer.dart';
import '../policy/quality_flow_policy.dart';
import 'quality_flow_state.dart';

class QualityGateCubit extends BaseCubit<QualityFlowState> {
  QualityGateCubit({
    required this._gate,
    required this._tasks,
    required this._announcer,
  }) : super(const QualityFlowState());

  final QualityGate _gate;
  final TaskController _tasks;
  final QualityAnnouncer _announcer;
  TaskHandle<QualityVerdict>? _current;

  Future<void> check(CapturedImage image) async {
    final handle = _tasks.start<QualityVerdict>(
      (_) => _gate.check(image),
      key: QualityFlowPolicy.taskKey,
    );
    _current = handle;
    safeEmit(state.to(QualityFlowStatus.checking, image));
    final outcome = await handle.result;
    if (!identical(_current, handle)) return;
    outcome.fold(
      onSuccess: (verdict) => _settle(image, verdict),
      onFailure: (failure) => _fail(image, failure),
    );
  }

  void retake() {
    _drop();
    safeEmit(const QualityFlowState());
  }

  @override
  Future<void> close() {
    _drop();
    return super.close();
  }

  void _settle(CapturedImage image, QualityVerdict verdict) {
    final issue = verdict.issue;
    if (issue == null) {
      safeEmit(state.to(QualityFlowStatus.accepted, image, verdict));
      return;
    }
    safeEmit(state.to(QualityFlowStatus.rejected, image, verdict));
    _announcer.announce(issue);
  }

  void _fail(CapturedImage image, Failure failure) {
    if (failure is CancelledFailure) return;
    safeEmit(state.to(QualityFlowStatus.failed, image));
    _announcer.announceFailure(failure);
  }

  void _drop() {
    _current?.cancel();
    _current = null;
    _announcer.cancel();
  }
}
