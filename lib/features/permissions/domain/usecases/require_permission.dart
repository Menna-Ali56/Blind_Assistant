import '../../../../core/errors/exceptions/permission_exception.dart';
import '../entities/access_status.dart';
import '../entities/permission_kind.dart';
import '../repositories/permission_repository.dart';

class RequirePermission {
  const RequirePermission(this._permissions);

  final PermissionRepository _permissions;

  Future<void> call(PermissionKind kind) async {
    final status = await _permissions.statusOf(kind);
    if (status.isGranted) return;
    throw PermissionException(
      permission: kind.key,
      isPermanentlyDenied: status == AccessStatus.blocked,
    );
  }
}
