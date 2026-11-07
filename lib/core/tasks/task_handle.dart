import 'dart:async';

import '../errors/failures/cancelled_failure.dart';
import '../errors/failures/failure.dart';
import '../errors/failures/timeout_failure.dart';
import '../errors/result/result.dart';
import 'task_cancel_token.dart';
import 'task_status.dart';

class TaskHandle<T> {
  TaskHandle(this.id, {Duration? timeout}) {
    unawaited(token.whenCancelled.then((_) => fail(const CancelledFailure())));
    if (timeout != null) _timer = Timer(timeout, _expire);
  }

  final String id;
  final TaskCancelToken token = TaskCancelToken();
  final Completer<Result<T>> _done = Completer<Result<T>>();
  TaskStatus _status = TaskStatus.pending;
  Timer? _timer;

  TaskStatus get status => _status;

  bool get isDone => _done.isCompleted;

  Future<Result<T>> get result => _done.future;

  void cancel() => token.cancel();

  void markProcessing() {
    if (!isDone) _status = TaskStatus.processing;
  }

  void succeed(T data) {
    _finish(ResultSuccess<T>(data), TaskStatus.completed);
  }

  void fail(Failure failure) {
    final isCancel = failure is CancelledFailure;
    final status = isCancel ? TaskStatus.cancelled : TaskStatus.failed;
    _finish(ResultFailure<T>(failure), status);
  }

  void _finish(Result<T> outcome, TaskStatus status) {
    if (isDone) return;
    _timer?.cancel();
    _status = status;
    _done.complete(outcome);
  }

  void _expire() {
    fail(const TimeoutFailure());
    cancel();
  }
}
