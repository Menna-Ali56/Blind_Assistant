import 'dart:async';

import 'package:baseer/core/errors/exceptions/network_exception.dart';
import 'package:baseer/core/errors/failures/failures.dart';
import 'package:baseer/core/tasks/tasks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'task_test_support.dart';

void main() {
  late TaskController controller;

  setUp(() => controller = TaskController());
  tearDown(() => controller.dispose());

  test('every task gets its own id', () {
    final first = controller.start((_) async => taskTestValue);
    final second = controller.start((_) async => taskTestValue);
    expect(first.id, isNot(second.id));
  });

  test('a running task is processing and active', () {
    final gate = Completer<int>();
    final handle = controller.start((_) => gate.future);
    expect(handle.status, TaskStatus.processing);
    expect(controller.isActive(handle.id), isTrue);
    expect(controller.activeCount, 1);
  });

  test('success gives the data and frees the task', () async {
    final handle = controller.start((_) async => taskTestValue);
    expect(dataOf(await handle.result), taskTestValue);
    expect(handle.status, TaskStatus.completed);
    expect(controller.isActive(handle.id), isFalse);
  });

  test('a thrown error becomes a mapped failure', () async {
    final handle = controller.start<int>(
      (_) async => throw const NetworkException(),
    );
    expect(failureOf(await handle.result), const NetworkFailure());
    expect(handle.status, TaskStatus.failed);
  });

  test('the action receives the token of its own handle', () async {
    late TaskCancelToken seen;
    final handle = controller.start((token) async => seen = token);
    await handle.result;
    expect(seen, same(handle.token));
  });
}
