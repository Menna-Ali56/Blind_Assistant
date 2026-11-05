import 'app_exception.dart';

class AppCameraException extends AppException {
  const AppCameraException({
    super.message = 'Camera unavailable',
    super.code = 'camera',
    super.cause,
  });
}
