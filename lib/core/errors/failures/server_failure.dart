import 'failure.dart';

class ServerFailure extends Failure {
  const ServerFailure()
      : super(messageKey: 'server_error', code: 'server', isRetryable: true);
}
