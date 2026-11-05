import 'app_exception.dart';

class MicrophoneException extends AppException {
  const MicrophoneException({
    super.message = 'Microphone unavailable',
    super.code = 'microphone',
    super.cause,
  });
}
