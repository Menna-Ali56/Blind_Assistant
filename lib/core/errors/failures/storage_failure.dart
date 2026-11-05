import 'failure.dart';

class StorageFailure extends Failure {
  const StorageFailure()
    : super(messageKey: 'storage_error', code: 'storage', isRetryable: true);
}
