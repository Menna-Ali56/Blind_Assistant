import 'app_exception.dart';

abstract final class AppPermission {
  static const camera = 'camera';
  static const microphone = 'microphone';
  static const speech = 'speech';
  static const storage = 'storage';
  static const location = 'location';
}

class PermissionException extends AppException {
  const PermissionException({
    super.message = 'Permission denied',
    super.code = 'permission',
    super.cause,
    this.permission,
    this.isPermanentlyDenied = false,
  });

  final String? permission;
  final bool isPermanentlyDenied;
}
