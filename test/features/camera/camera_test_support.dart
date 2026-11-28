import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/features/camera/data/camera_driver.dart';
import 'package:baseer/features/camera/data/device_camera_service.dart';
import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:baseer/features/permissions/domain/entities/permission_kind.dart';
import 'package:baseer/features/permissions/domain/usecases/require_permission.dart';
import 'package:flutter/widgets.dart';

import '../permissions/permission_test_support.dart';

final Uint8List cameraTestBytes = Uint8List.fromList([1, 2, 3]);
final DateTime cameraTestTime = DateTime.utc(2026, 1, 1);

class FakeCameraDriver implements CameraDriver {
  Object? openError;
  Object? captureError;
  Uint8List bytes = cameraTestBytes;
  Completer<Uint8List>? gate;
  int opens = 0;
  int closes = 0;

  @override
  Future<void> open() async {
    opens++;
    if (openError != null) throw openError!;
  }

  @override
  Future<Uint8List> takePicture() async {
    if (captureError != null) throw captureError!;
    return gate?.future ?? bytes;
  }

  @override
  Future<void> close() async => closes++;

  @override
  Widget buildPreview() => const SizedBox.shrink();
}

class CameraHarness {
  CameraHarness({AccessStatus access = AccessStatus.granted}) {
    permissions.current[PermissionKind.camera] = access;
    service = DeviceCameraService(
      driver: driver,
      requirePermission: RequirePermission(permissions),
      now: () => cameraTestTime,
    );
  }

  final FakeCameraDriver driver = FakeCameraDriver();
  final FakePermissionRepository permissions = FakePermissionRepository();
  late final DeviceCameraService service;
}
