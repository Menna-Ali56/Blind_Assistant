import 'app_exception.dart';

class ModelException extends AppException {
  const ModelException({
    super.message = 'AI model failed',
    super.code = 'model',
    super.cause,
  });
}
