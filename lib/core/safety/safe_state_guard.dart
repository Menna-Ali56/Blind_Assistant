import 'dart:async';

import 'package:flutter/foundation.dart';

import '../errors/errors.dart';
import '../tasks/task_controller.dart';
import 'safe_state_policy.dart';

class SafeStateGuard {
  SafeStateGuard({
    required this._supervisor,
    required this._tasks,
    required this._goHome,
    this._policy = const SafeStatePolicy(),
  });

  final ErrorSupervisor _supervisor;
  final TaskController _tasks;
  final VoidCallback _goHome;
  final SafeStatePolicy _policy;
  StreamSubscription<ErrorReport>? _subscription;

  void start() {
    _subscription ??= _supervisor.reports
        .where(_policy.requiresSafeState)
        .listen((_) => _enter());
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  void _enter() {
    _tasks.cancelAll();
    _goHome();
  }
}
