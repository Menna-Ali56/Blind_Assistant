import 'package:baseer/features/permissions/permissions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'permission_test_support.dart';

void main() {
  late PermissionsHarness harness;

  setUp(() => harness = PermissionsHarness());

  tearDown(() => harness.cubit.close());

  group('flow', () {
    test('skip moves to the next permission', () async {
      await harness.cubit.refresh();

      harness.cubit.skip(PermissionKind.camera);

      expect(harness.cubit.state.pending, PermissionKind.microphone);
    });

    test('is complete when all are granted or skipped', () async {
      await harness.cubit.refresh();

      PermissionKind.values.forEach(harness.cubit.skip);

      expect(harness.cubit.state.isComplete, isTrue);
    });

    test('needsFlow is false when everything is granted', () async {
      for (final kind in PermissionKind.values) {
        harness.repository.current[kind] = AccessStatus.granted;
      }

      expect(await harness.cubit.needsFlow(), isFalse);
      expect(harness.progress.isCompleted, isTrue);
    });

    test('needsFlow is true until the flow finishes', () async {
      expect(await harness.cubit.needsFlow(), isTrue);

      harness.cubit.finish();

      expect(await harness.cubit.needsFlow(), isFalse);
    });

    test('announce speaks the purpose of the permission', () async {
      harness.cubit.announce(PermissionKind.microphone);
      await pumpEventQueue();

      expect(harness.channel.spoken.single, contains('voice commands'));
    });

    test('announce stays quiet when a screen reader is active', () async {
      final readerHarness = PermissionsHarness(
        screenReader: FakeScreenReaderStatus(isActive: true),
      );
      addTearDown(readerHarness.cubit.close);

      readerHarness.cubit.announce(PermissionKind.camera);
      await pumpEventQueue();

      expect(readerHarness.channel.spoken, isEmpty);
    });

    test('openSettings reaches the repository', () async {
      await harness.cubit.openSettings();

      expect(harness.repository.settingsOpened, 1);
    });
  });
}
