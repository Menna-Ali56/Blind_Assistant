import 'package:baseer/features/permissions/data/repositories/permission_handler_repository.dart';
import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

void main() {
  const expected = {
    handler.PermissionStatus.granted: AccessStatus.granted,
    handler.PermissionStatus.limited: AccessStatus.granted,
    handler.PermissionStatus.denied: AccessStatus.denied,
    handler.PermissionStatus.permanentlyDenied: AccessStatus.blocked,
    handler.PermissionStatus.restricted: AccessStatus.blocked,
  };

  for (final entry in expected.entries) {
    test('${entry.key.name} maps to ${entry.value.name}', () {
      expect(accessStatusOf(entry.key), entry.value);
    });
  }
}
