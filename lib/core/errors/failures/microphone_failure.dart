import 'failure.dart';

class MicrophoneFailure extends Failure {
  const MicrophoneFailure()
      : super(messageKey: 'microphone_unavailable', code: 'microphone', isRetryable: true);
}
