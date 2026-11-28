import 'package:baseer/core/errors/exceptions/permission_exception.dart';
import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:baseer/features/permissions/domain/entities/permission_kind.dart';
import 'package:baseer/features/permissions/domain/usecases/require_permission.dart';
import 'package:flutter_test/flutter_test.dart';

import 'permission_test_support.dart';

void main() {
  RequirePermission build(AccessStatus status) => RequirePermission(
    FakePermissionRepository(
      current: {for (final kind in PermissionKind.values) kind: status},
    ),
  );

  for (final kind in PermissionKind.values) {
    test('granted ${kind.name} passes', () async {
      await build(AccessStatus.granted)(kind);
    });

    test('denied ${kind.name} throws a recoverable exception', () {
      expect(
        build(AccessStatus.denied)(kind),
        throwsA(
          isA<PermissionException>()
              .having((e) => e.permission, 'permission', kind.key)
              .having((e) => e.isPermanentlyDenied, 'blocked', isFalse),
        ),
      );
    });

    test('blocked ${kind.name} throws a blocked exception', () {
      expect(
        build(AccessStatus.blocked)(kind),
        throwsA(
          isA<PermissionException>().having(
            (e) => e.isPermanentlyDenied,
            'blocked',
            isTrue,
          ),
        ),
      );
    });
  }
}
