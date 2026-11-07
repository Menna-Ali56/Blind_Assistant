import 'dart:async';

import '../errors/failures/cancelled_failure.dart';
import '../errors/failures/failure.dart';
import '../errors/handlers/error_handler.dart';
import 'task_action.dart';
import 'task_cancel_token.dart';
import 'task_cancelled_exception.dart';
import 'task_handle.dart';
import 'task_id_generator.dart';

/// Gives every task an id and a cancel token and drops late results
class TaskController {
  TaskController({
    TaskIdGenerator? idGenerator,
    ErrorHandler errorHandler = const ErrorHandler(),
  }) : _ids = idGenerator ?? UuidV4Generator(),
       _errors = errorHandler;

  static const String _logContext = 'task_controller';

  final TaskIdGenerator _ids;
  final ErrorHandler _errors;
  final Map<String, TaskCancelToken> _tokens = {};
  final Map<String, String> _idByKey = {};

  int get activeCount => _tokens.length;

  bool isActive(String id) => _tokens.containsKey(id);

  TaskHandle<T> start<T>(
    TaskAction<T> action, {
    String? key,
    Duration? timeout,
  }) {
    final superseded = _idByKey[key];
    if (superseded != null) cancel(superseded);
    final handle = TaskHandle<T>(_ids.next(), timeout: timeout);
    _register(handle, key);
    unawaited(_run(handle, action));
    return handle;
  }

  bool cancel(String id) {
    final token = _tokens[id];
    token?.cancel();
    return token != null;
  }

  void cancelAll() {
    for (final token in List.of(_tokens.values)) {
      token.cancel();
    }
  }

  void dispose() => cancelAll();

  void _register<T>(TaskHandle<T> handle, String? key) {
    _tokens[handle.id] = handle.token;
    if (key != null) _idByKey[key] = handle.id;
    unawaited(handle.result.whenComplete(() => _release(handle.id, key)));
  }

  void _release(String id, String? key) {
    _tokens.remove(id);
    if (_idByKey[key] == id) _idByKey.remove(key);
  }

  Future<void> _run<T>(TaskHandle<T> handle, TaskAction<T> action) async {
    handle.markProcessing();
    try {
      handle.succeed(await action(handle.token));
    } catch (error, stackTrace) {
      if (!handle.isDone) handle.fail(_failureOf(error, stackTrace));
    }
  }

  Failure _failureOf(Object error, StackTrace stackTrace) {
    if (error is TaskCancelledException) return const CancelledFailure();
    return _errors.handle(error, stackTrace, context: _logContext);
  }
}
