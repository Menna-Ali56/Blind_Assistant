import 'failure.dart';

class ModelFailure extends Failure {
  const ModelFailure()
      : super(messageKey: 'model_error', code: 'model', isRetryable: true);
}
