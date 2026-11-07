import 'dart:async';

import 'task_cancelled_exception.dart';

class TaskCancelToken {
  final Completer<void> _signal = Completer<void>.sync();

  bool get isCancelled => _signal.isCompleted;

  Future<void> get whenCancelled => _signal.future;

  void cancel() {
    if (!isCancelled) _signal.complete();
  }

  void throwIfCancelled() {
    if (isCancelled) throw const TaskCancelledException();
  }
}
