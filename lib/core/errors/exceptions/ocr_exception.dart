import 'app_exception.dart';

class OcrException extends AppException {
  const OcrException({
    super.message = 'Text recognition failed',
    super.code = 'ocr',
    super.cause,
  });

  const OcrException.noText({
    super.message = 'No text found in the image',
    super.code = 'ocr_no_text',
    super.cause,
  });
}