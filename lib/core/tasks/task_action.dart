import 'task_cancel_token.dart';

typedef TaskAction<T> = Future<T> Function(TaskCancelToken token);
