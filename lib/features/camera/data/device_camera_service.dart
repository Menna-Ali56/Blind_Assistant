import 'package:flutter/widgets.dart';

import '../../../core/errors/exceptions/camera_exception.dart';
import '../../permissions/domain/entities/permission_kind.dart';
import '../../permissions/domain/usecases/require_permission.dart';
import '../domain/entities/camera_status.dart';
import '../domain/entities/captured_image.dart';
import '../domain/repositories/camera_service.dart';
import 'camera_driver.dart';
import 'camera_error_codes.dart';
import 'camera_error_mapper.dart';
import 'serial_queue.dart';

class DeviceCameraService implements CameraService {
  DeviceCameraService({
    required this._driver,
    required this._requirePermission,
    this._now = DateTime.now,
  });

  final CameraDriver _driver;
  final RequirePermission _requirePermission;
  final DateTime Function() _now;
  CameraStatus _status = CameraStatus.closed;
  final SerialQueue _queue = SerialQueue();
  Future<void> _capture = Future.value();

  @override
  CameraStatus get status => _status;

  @override
  Future<void> open() => _queue.run(_open);

  @override
  Future<void> pause() => _queue.run(_pause);

  @override
  Future<void> resume() => _queue.run(() async {
    if (_status == CameraStatus.paused) await _open();
  });

  @override
  Future<void> dispose() => _queue.run(() => _release(CameraStatus.closed));

  @override
  Widget buildPreview() => _driver.buildPreview();

  @override
  Future<CapturedImage> capture() async {
    if (!_status.isReady) {
      throw const AppCameraException(code: CameraErrorCodes.notReady);
    }
    _status = CameraStatus.capturing;
    try {
      final job = CameraErrorMapper.guard(_driver.takePicture);
      _capture = job.then<void>((_) {}, onError: (_) {});
      final bytes = await job;
      if (bytes.isEmpty) {
        throw const AppCameraException(code: CameraErrorCodes.emptyCapture);
      }
      return CapturedImage(bytes: bytes, capturedAt: _now());
    } finally {
      _settle(CameraStatus.capturing, CameraStatus.ready);
    }
  }

  Future<void> _open() async {
    if (_status.isActive) return;
    await CameraErrorMapper.guard(
      () => _requirePermission(PermissionKind.camera),
    );
    _status = CameraStatus.opening;
    try {
      await CameraErrorMapper.guard(_driver.open);
      _settle(CameraStatus.opening, CameraStatus.ready);
    } catch (_) {
      _settle(CameraStatus.opening, CameraStatus.closed);
      rethrow;
    }
  }

  Future<void> _pause() async {
    if (!_status.isActive) return;
    await _capture;
    await _release(CameraStatus.paused);
  }

  Future<void> _release(CameraStatus next) async {
    _status = next;
    await CameraErrorMapper.guard(_driver.close);
  }

  void _settle(CameraStatus from, CameraStatus to) {
    if (_status == from) _status = to;
  }
}
