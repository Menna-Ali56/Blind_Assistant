import 'package:permission_handler/permission_handler.dart' as handler;

import '../../domain/entities/access_status.dart';
import '../../domain/entities/permission_kind.dart';
import '../../domain/repositories/permission_repository.dart';

const Map<PermissionKind, handler.Permission> _platformPermissions = {
  PermissionKind.camera: handler.Permission.camera,
  PermissionKind.microphone: handler.Permission.microphone,
  PermissionKind.location: handler.Permission.locationWhenInUse,
};

AccessStatus accessStatusOf(handler.PermissionStatus status) {
  if (status.isGranted || status.isLimited) return AccessStatus.granted;
  if (status.isPermanentlyDenied || status.isRestricted) {
    return AccessStatus.blocked;
  }
  return AccessStatus.denied;
}

class PermissionHandlerRepository implements PermissionRepository {
  const PermissionHandlerRepository();

  @override
  Future<AccessStatus> statusOf(PermissionKind kind) async =>
      accessStatusOf(await _platformPermissions[kind]!.status);

  @override
  Future<Map<PermissionKind, AccessStatus>> statuses() async {
    final entries = await Future.wait(
      PermissionKind.values.map(
        (kind) async => MapEntry(kind, await statusOf(kind)),
      ),
    );
    return Map.fromEntries(entries);
  }

  @override
  Future<AccessStatus> request(PermissionKind kind) async =>
      accessStatusOf(await _platformPermissions[kind]!.request());

  @override
  Future<bool> openSettings() => handler.openAppSettings();
}
