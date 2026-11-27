import '../../../../core/audio/microphone_access.dart';
import '../../domain/entities/access_status.dart';
import '../../domain/entities/permission_kind.dart';
import '../../domain/repositories/permission_repository.dart';

/// Tells the audio code what the permissions feature knows.
class PermissionMicrophoneAccess implements MicrophoneAccess {
  const PermissionMicrophoneAccess(this._permissions);

  final PermissionRepository _permissions;

  @override
  Future<MicrophoneStatus> status() async =>
      switch (await _permissions.statusOf(PermissionKind.microphone)) {
        AccessStatus.granted => MicrophoneStatus.granted,
        AccessStatus.denied => MicrophoneStatus.denied,
        AccessStatus.blocked => MicrophoneStatus.blocked,
      };
}
