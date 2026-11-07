import 'dart:async';

import 'package:baseer/core/errors/failures/failures.dart';
import 'package:baseer/core/tasks/tasks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'task_test_support.dart';

void main() {
  late TaskController controller;

  setUp(() => controller = TaskController());
  tearDown(() => controller.dispose());

  test('a new task with the same key cancels the old one', () async {
    final first = controller.start(
      (_) => Completer<int>().future,
      key: taskTestKey,
    );
    final second = controller.start(
      (_) async => taskTestValue,
      key: taskTestKey,
    );
    expect(failureOf(await first.result), const CancelledFailure());
    expect(dataOf(await second.result), taskTestValue);
  });

  test('tasks with different keys do not cancel each other', () async {
    final first = controller.start(
      (_) async => taskTestValue,
      key: taskTestKey,
    );
    final second = controller.start(
      (_) async => taskTestValue,
      key: taskTestOtherKey,
    );
    expect(dataOf(await first.result), taskTestValue);
    expect(dataOf(await second.result), taskTestValue);
  });

  test('cancel all ends every active task', () async {
    final first = controller.start((_) => Completer<int>().future);
    final second = controller.start((_) => Completer<int>().future);
    controller.cancelAll();
    await Future.wait([first.result, second.result]);
    expect(first.status, TaskStatus.cancelled);
    expect(second.status, TaskStatus.cancelled);
    expect(controller.activeCount, 0);
  });
}
