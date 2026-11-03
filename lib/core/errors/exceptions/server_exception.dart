import 'app_exception.dart';

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error',
    super.code = 'server',
    super.cause,
  });
}
