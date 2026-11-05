import 'failure.dart';

class TimeoutFailure extends Failure {
  const TimeoutFailure()
    : super(messageKey: 'timeout_error', code: 'timeout', isRetryable: true);
}
