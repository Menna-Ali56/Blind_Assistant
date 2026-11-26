import '../../../core/errors/exceptions/permission_exception.dart';
import '../../permissions/domain/entities/access_status.dart';
import '../../permissions/domain/entities/permission_kind.dart';
import '../../permissions/domain/repositories/permission_repository.dart';

class MicrophoneGuard {
  const MicrophoneGuard(this._permissions);

  final PermissionRepository _permissions;

  Future<void> require() async {
    final status = await _permissions.statusOf(PermissionKind.microphone);
    if (status.isGranted) return;
    throw PermissionException(
      permission: PermissionKind.microphone.key,
      isPermanentlyDenied: status == AccessStatus.blocked,
    );
  }
}
