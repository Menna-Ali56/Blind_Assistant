import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:baseer/features/permissions/domain/entities/permission_kind.dart';
import 'package:baseer/features/permissions/presentation/texts/permission_texts_lookup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final language in ['ar', 'en']) {
    group(language, () {
      final texts = permissionTextsFor(language);

      test('every permission has a label and a purpose', () {
        for (final kind in PermissionKind.values) {
          expect(texts.label(kind), isNotEmpty);
          expect(texts.purpose(kind), isNotEmpty);
        }
      });

      test('status messages name the permission', () {
        for (final kind in PermissionKind.values) {
          for (final status in AccessStatus.values) {
            expect(
              texts.statusMessage(kind, status),
              contains(texts.label(kind)),
            );
          }
        }
      });
    });
  }

  test('unknown language falls back to english', () {
    expect(permissionTextsFor('fr'), permissionTextsFor('en'));
  });

  test('blocked announcement points to settings', () {
    final texts = permissionTextsFor('en');
    expect(
      texts.announcement(PermissionKind.camera, AccessStatus.blocked),
      texts.statusMessage(PermissionKind.camera, AccessStatus.blocked),
    );
  });
}
