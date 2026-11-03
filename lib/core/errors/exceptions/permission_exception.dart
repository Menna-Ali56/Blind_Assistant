import 'app_exception.dart';

/// Names used by PermissionException / PermissionFailure.
abstract final class AppPermission {
  static const camera = 'camera';
  static const microphone = 'microphone';
  static const speech = 'speech';
  static const storage = 'storage';
}

class PermissionException extends AppException {
  const PermissionException({
    super.message = 'Permission denied',
    super.code = 'permission',
    super.cause,
    this.permission,
    this.isPermanentlyDenied = false,
  });

  /// One of [AppPermission], or null if unknown.
  final String? permission;

  /// true => the user must enable it from system settings.
  final bool isPermanentlyDenied;
}