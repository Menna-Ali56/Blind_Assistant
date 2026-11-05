import 'failure.dart';

class SpeechFailure extends Failure {
  const SpeechFailure()
    : super(messageKey: 'speech_error', code: 'speech', isRetryable: true);
}
