import 'package:baseer/features/permissions/permissions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'permission_test_support.dart';

void main() {
  late PermissionsHarness harness;

  setUp(() => harness = PermissionsHarness());

  tearDown(() => harness.cubit.close());

  group('refresh', () {
    test('loads every status and shares the granted names', () async {
      harness.repository.current[PermissionKind.camera] = AccessStatus.granted;

      await harness.cubit.refresh();

      expect(harness.cubit.state.loaded, isTrue);
      expect(harness.granted.names, {PermissionKind.camera.key});
    });

    test('speaks when a permission is granted later', () async {
      await harness.cubit.refresh();
      harness.repository.current[PermissionKind.location] =
          AccessStatus.granted;

      await harness.cubit.refresh();
      await pumpEventQueue();

      expect(harness.channel.spoken, hasLength(1));
      expect(harness.channel.spoken.single, contains('location'));
    });

    test('stays quiet on the first load', () async {
      harness.repository.current[PermissionKind.camera] = AccessStatus.granted;

      await harness.cubit.refresh();
      await pumpEventQueue();

      expect(harness.channel.spoken, isEmpty);
    });
  });

  group('request', () {
    test('granted answer is stored and spoken', () async {
      await harness.cubit.refresh();

      await harness.cubit.request(PermissionKind.camera);
      await pumpEventQueue();

      expect(
        harness.cubit.state.statusOf(PermissionKind.camera).isGranted,
        isTrue,
      );
      expect(harness.channel.spoken.single, contains('camera'));
    });

    test('denied answer keeps the permission pending', () async {
      harness.repository.requestResult = AccessStatus.denied;
      await harness.cubit.refresh();

      await harness.cubit.request(PermissionKind.camera);
      await pumpEventQueue();

      expect(harness.cubit.state.pending, PermissionKind.camera);
      expect(harness.channel.spoken.single, contains('not allowed'));
    });

    test('blocked answer asks for settings', () async {
      harness.repository.requestResult = AccessStatus.blocked;
      await harness.cubit.refresh();

      await harness.cubit.request(PermissionKind.microphone);
      await pumpEventQueue();

      expect(harness.channel.spoken.single, contains('settings'));
    });
  });
}
