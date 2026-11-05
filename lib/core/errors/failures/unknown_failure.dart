import 'failure.dart';

class UnknownFailure extends Failure {
  const UnknownFailure()
    : super(messageKey: 'unexpected_error', code: 'unknown');
}
