import 'package:camera/camera.dart' as plugin;

import '../../../core/errors/exceptions/app_exception.dart';
import '../../../core/errors/exceptions/camera_exception.dart';
import '../../../core/errors/exceptions/permission_exception.dart';

abstract final class CameraErrorMapper {
  static const Set<String> _blockedCodes = {
    'CameraAccessDeniedWithoutPrompt',
    'CameraAccessRestricted',
  };

  static const Set<String> _deniedCodes = {
    'CameraAccessDenied',
    ..._blockedCodes,
  };

  static AppException map(Object error) {
    if (error is AppException) return error;
    if (error is plugin.CameraException && _deniedCodes.contains(error.code)) {
      return PermissionException(
        permission: AppPermission.camera,
        isPermanentlyDenied: _blockedCodes.contains(error.code),
        cause: error,
      );
    }
    return AppCameraException(cause: error);
  }

  static Future<T> guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error) {
      throw map(error);
    }
  }
}
