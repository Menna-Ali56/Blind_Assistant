import 'dart:typed_data';

import 'package:baseer/core/errors/exceptions/model_exception.dart';
import 'package:baseer/core/errors/exceptions/permission_exception.dart';
import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:baseer/features/permissions/domain/entities/permission_kind.dart';
import 'package:flutter_test/flutter_test.dart';

import 'spotter_harness.dart';

void main() {
  test('blocked microphone throws and never opens the source', () async {
    final h = SpotterHarness();
    h.permissions.current[PermissionKind.microphone] = AccessStatus.blocked;
    await expectLater(
      h.spotter.start(),
      throwsA(
        isA<PermissionException>().having(
          (e) => e.isPermanentlyDenied,
          'blocked',
          true,
        ),
      ),
    );
    expect(h.source.starts, 0);
  });

  test('engine creation failure becomes a model exception', () async {
    final h = SpotterHarness(engineFactory: (_) => throw StateError('native'));
    await expectLater(h.spotter.start(), throwsA(isA<ModelException>()));
    expect(h.source.starts, 0);
  });

  test('engine failure reports the error and stops', () async {
    final h = SpotterHarness();
    h.engine.failure = StateError('boom');
    await h.spotter.start();
    h.source.controller.add(Uint8List(4));
    await settle();
    expect(h.errors.single, isA<StateError>());
    expect(h.engine.disposed, isTrue);
  });
}
