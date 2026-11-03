import 'app_exception.dart';

class SpeechException extends AppException {
  const SpeechException({
    super.message = 'Speech operation failed',
    super.code = 'speech',
    super.cause,
  });
}
