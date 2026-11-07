import '../errors/exceptions/app_exception.dart';

class TaskCancelledException extends AppException {
  const TaskCancelledException({
    super.message = 'Task cancelled',
    super.code = 'cancelled',
    super.cause,
  });
}
