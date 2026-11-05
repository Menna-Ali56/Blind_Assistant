import 'failure.dart';

class CancelledFailure extends Failure {
  const CancelledFailure() : super(messageKey: 'cancelled', code: 'cancelled');
}
