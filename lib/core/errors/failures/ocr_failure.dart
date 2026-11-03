import 'failure.dart';

class OcrFailure extends Failure {
  const OcrFailure()
      : super(messageKey: 'ocr_error', code: 'ocr', isRetryable: true);
}
