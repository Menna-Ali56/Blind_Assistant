import '../../../../core/errors/exceptions/permission_exception.dart';

enum PermissionKind {
  camera(AppPermission.camera),
  microphone(AppPermission.microphone),
  location(AppPermission.location);

  const PermissionKind(this.key);

  final String key;
}
