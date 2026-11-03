import 'failure.dart';

class OcrFailure extends Failure {
  const OcrFailure()
      : super(messageKey: 'ocr_error', code: 'ocr', isRetryable: true);

  const OcrFailure.noText()
      : super(messageKey: 'ocr_no_text', code: 'ocr_no_text', isRetryable: true);
}