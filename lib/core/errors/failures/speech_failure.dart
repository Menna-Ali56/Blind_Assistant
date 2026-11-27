import 'failure.dart';

class SpeechFailure extends Failure {
  const SpeechFailure()
    : super(messageKey: 'speech_error', code: 'speech', isRetryable: true);

  /// The microphone worked but nobody spoke.
  const SpeechFailure.noInput()
    : super(
        messageKey: 'speech_no_input',
        code: 'speech_no_input',
        isRetryable: true,
      );
}
