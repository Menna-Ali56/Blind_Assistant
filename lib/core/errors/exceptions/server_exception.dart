import 'app_exception.dart';

class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    super.message = 'Server error',
    super.code = 'server',
    super.cause,
    this.statusCode,
  });
}