import 'dart:async';

import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/safety/safety.dart';
import 'package:baseer/core/tasks/task_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ErrorSupervisor supervisor;
  late TaskController tasks;
  late int goHomeCalls;
  late SafeStateGuard guard;

  setUp(() {
    supervisor = ErrorSupervisor();
    tasks = TaskController();
    goHomeCalls = 0;
    guard = SafeStateGuard(
      supervisor: supervisor,
      tasks: tasks,
      goHome: () => goHomeCalls++,
    )..start();
  });

  tearDown(() async {
    await guard.stop();
    tasks.dispose();
    await supervisor.dispose();
  });

  test(
    'critical report cancels active tasks and navigates home once',
    () async {
      final completer = Completer<void>();
      tasks.start<void>((token) async {
        token.throwIfCancelled();
        await completer.future;
      });
      expect(tasks.activeCount, 1);

      supervisor.report(
        StateError('boom'),
        stackTrace: StackTrace.current,
        source: 'test',
        uncaught: true,
        log: false,
      );
      await pumpEventQueue();

      expect(tasks.activeCount, 0);
      expect(goHomeCalls, 1);
    },
  );
}
