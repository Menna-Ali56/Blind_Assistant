import 'package:flutter/services.dart' show PlatformException;

import '../exceptions/permission_exception.dart';
import '../failures/failures.dart';

class PlatformFailureMapper {
  const PlatformFailureMapper();

  static const _deniedHints = [
    'denied',
    'permission',
    'unauthorized',
    'restricted',
  ];

  static const _permissionHints = {
    AppPermission.camera: ['camera'],
    AppPermission.microphone: ['audio', 'microphone', 'record'],
    AppPermission.speech: ['speech'],
    AppPermission.storage: ['storage', 'file'],
  };

  Failure map(PlatformException error) {
    final code = error.code.toLowerCase();
    final permission = _permissionIn(code);
    if (_deniedHints.any(code.contains)) {
      return PermissionFailure(
        permission: permission,
        isPermanentlyDenied: code.contains('permanent'),
      );
    }
    return switch (permission) {
      AppPermission.camera => const CameraFailure(),
      AppPermission.microphone => const MicrophoneFailure(),
      AppPermission.speech => const SpeechFailure(),
      AppPermission.storage => const StorageFailure(),
      _ => const UnknownFailure(),
    };
  }

  String? _permissionIn(String code) {
    for (final entry in _permissionHints.entries) {
      if (entry.value.any(code.contains)) return entry.key;
    }
    return null;
  }
}
