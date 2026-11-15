import '../mappers/error_code_registry.dart';
import 'failure.dart';

class UnknownFailure extends Failure {
  const UnknownFailure()
    : super(messageKey: ErrorCodeRegistry.unknownMessageKey, code: 'unknown');
}
