import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/core/errors/failures/failures.dart';
import 'package:baseer/features/camera/data/camera_lifecycle_observer.dart';
import 'package:baseer/features/camera/domain/entities/camera_status.dart';
import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:baseer/features/permissions/domain/entities/permission_kind.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'camera_test_support.dart';

void main() {
  late CameraHarness harness;
  late List<Failure> failures;
  late CameraLifecycleObserver observer;

  setUp(() async {
    harness = CameraHarness();
    failures = [];
    observer = CameraLifecycleObserver(
      service: harness.service,
      onFailure: failures.add,
    );
    await harness.service.open();
  });

  Future<void> moveTo(AppLifecycleState state) async {
    observer.didChangeAppLifecycleState(state);
    await pumpEventQueue();
  }

  test('pause closes the driver and resume opens it again', () async {
    await moveTo(AppLifecycleState.paused);
    expect(harness.service.status, CameraStatus.paused);
    expect(harness.driver.closes, 1);
    await moveTo(AppLifecycleState.resumed);
    expect(harness.service.status, CameraStatus.ready);
    expect(harness.driver.opens, 2);
  });

  test('inactive and hidden also pause', () async {
    await moveTo(AppLifecycleState.inactive);
    expect(harness.service.status, CameraStatus.paused);
  });

  test('resume without a pause does nothing', () async {
    await moveTo(AppLifecycleState.resumed);
    expect(harness.driver.opens, 1);
  });

  test('pause waits for a running capture', () async {
    harness.driver.gate = Completer<Uint8List>();
    final capture = harness.service.capture();
    final pause = harness.service.pause();
    await pumpEventQueue();
    expect(harness.driver.closes, 0);
    harness.driver.gate!.complete(cameraTestBytes);
    await capture;
    await pause;
    expect(harness.driver.closes, 1);
  });

  test('resume failure reaches the failure callback', () async {
    await moveTo(AppLifecycleState.paused);
    harness.permissions.current[PermissionKind.camera] = AccessStatus.blocked;
    await moveTo(AppLifecycleState.resumed);
    expect(failures.single, isA<PermissionFailure>());
    expect(harness.service.status, CameraStatus.paused);
  });

  test('dispose closes the camera', () async {
    await harness.service.dispose();
    expect(harness.service.status, CameraStatus.closed);
    expect(harness.driver.closes, 1);
  });
}
