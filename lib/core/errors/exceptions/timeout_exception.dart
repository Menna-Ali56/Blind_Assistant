import 'app_exception.dart';

class AppTimeoutException extends AppException {
  const AppTimeoutException({
    super.message = 'Request timed out',
    super.code = 'timeout',
    super.cause,
  });
}
