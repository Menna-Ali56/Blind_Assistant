import 'app_exception.dart';

class PermissionException extends AppException {
  const PermissionException({
    super.message = 'Permission denied',
    super.code = 'permission',
    super.cause,
  });
}
