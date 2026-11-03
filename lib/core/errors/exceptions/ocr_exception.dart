import 'app_exception.dart';

class OcrException extends AppException {
  const OcrException({
    super.message = 'Text recognition failed',
    super.code = 'ocr',
    super.cause,
  });
}
