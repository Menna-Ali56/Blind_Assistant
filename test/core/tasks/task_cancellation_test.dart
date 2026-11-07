import 'dart:async';

import 'package:baseer/core/errors/failures/failures.dart';
import 'package:baseer/core/tasks/tasks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'task_test_support.dart';

void main() {
  late TaskController controller;

  setUp(() => controller = TaskController());
  tearDown(() => controller.dispose());

  test('cancel ends the task at once as cancelled', () async {
    final handle = controller.start((_) => Completer<int>().future);
    expect(controller.cancel(handle.id), isTrue);
    expect(failureOf(await handle.result), const CancelledFailure());
    expect(handle.status, TaskStatus.cancelled);
    expect(handle.token.isCancelled, isTrue);
  });

  test('cancel of an unknown id does nothing', () {
    expect(controller.cancel('missing'), isFalse);
  });

  test('a late success after cancel is dropped', () async {
    final gate = Completer<int>();
    final handle = controller.start((_) => gate.future);
    handle.cancel();
    gate.complete(taskTestValue);
    await pumpEventQueue();
    expect(failureOf(await handle.result), const CancelledFailure());
    expect(handle.status, TaskStatus.cancelled);
  });

  test('a late error after cancel is dropped', () async {
    final gate = Completer<int>();
    final handle = controller.start((_) => gate.future);
    handle.cancel();
    gate.completeError(StateError('late'));
    await pumpEventQueue();
    expect(failureOf(await handle.result), const CancelledFailure());
  });

  test('a cancel exception from the action ends as cancelled', () async {
    final handle = controller.start<int>(
      (_) async => throw const TaskCancelledException(),
    );
    expect(failureOf(await handle.result), const CancelledFailure());
    expect(handle.status, TaskStatus.cancelled);
  });

  test('cancel after the end keeps the result', () async {
    final handle = controller.start((_) async => taskTestValue);
    await handle.result;
    handle.cancel();
    expect(handle.status, TaskStatus.completed);
  });

  test('a timeout fails the task and cancels the token', () async {
    final handle = controller.start(
      (_) => Completer<int>().future,
      timeout: taskTestTimeout,
    );
    expect(failureOf(await handle.result), const TimeoutFailure());
    expect(handle.status, TaskStatus.failed);
    expect(handle.token.isCancelled, isTrue);
  });
}
