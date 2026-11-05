import 'failure.dart';

class NetworkFailure extends Failure {
  const NetworkFailure()
    : super(messageKey: 'network_error', code: 'network', isRetryable: true);
}
