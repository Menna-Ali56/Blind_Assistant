import 'app_exception.dart';

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network unavailable',
    super.code = 'network',
    super.cause,
  });
}
