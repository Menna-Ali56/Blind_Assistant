import 'package:baseer/core/audio/microphone_access.dart';
import 'package:baseer/features/permissions/data/repositories/permission_microphone_access.dart';
import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:baseer/features/permissions/domain/entities/permission_kind.dart';
import 'package:baseer/features/permissions/domain/repositories/permission_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePermissionRepository implements PermissionRepository {
  AccessStatus status = AccessStatus.granted;
  PermissionKind? asked;

  @override
  Future<AccessStatus> statusOf(PermissionKind kind) async {
    asked = kind;
    return status;
  }

  @override
  Future<Map<PermissionKind, AccessStatus>> statuses() async => {};

  @override
  Future<AccessStatus> request(PermissionKind kind) async => status;

  @override
  Future<bool> openSettings() async => true;
}

void main() {
  test('maps each permission status and asks about the microphone', () async {
    final repository = FakePermissionRepository();
    final access = PermissionMicrophoneAccess(repository);

    final expected = {
      AccessStatus.granted: MicrophoneStatus.granted,
      AccessStatus.denied: MicrophoneStatus.denied,
      AccessStatus.blocked: MicrophoneStatus.blocked,
    };
    for (final entry in expected.entries) {
      repository.status = entry.key;
      expect(await access.status(), entry.value);
    }
    expect(repository.asked, PermissionKind.microphone);
  });
}
