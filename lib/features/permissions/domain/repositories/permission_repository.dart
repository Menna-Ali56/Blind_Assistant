import '../entities/access_status.dart';
import '../entities/permission_kind.dart';

abstract interface class PermissionRepository {
  Future<AccessStatus> statusOf(PermissionKind kind);

  Future<Map<PermissionKind, AccessStatus>> statuses();

  Future<AccessStatus> request(PermissionKind kind);

  Future<bool> openSettings();
}
