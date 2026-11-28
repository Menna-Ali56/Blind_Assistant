import 'package:flutter/widgets.dart';

import '../../../core/errors/failures/failure.dart';
import '../../camera/data/camera_lifecycle_observer.dart';
import '../../camera/domain/entities/captured_image.dart';
import '../../camera/domain/repositories/camera_service.dart';
import '../domain/repositories/camera_session.dart';

class CameraServiceSession implements CameraSession {
  CameraServiceSession(
    this._service, {
    required void Function(Failure failure) onFailure,
  }) {
    _observer = CameraLifecycleObserver(
      service: _service,
      onFailure: onFailure,
    );
  }

  final CameraService _service;
  late final CameraLifecycleObserver _observer;
  bool _attached = false;

  @override
  Future<void> open() async {
    if (!_attached) {
      _observer.attach();
      _attached = true;
    }
    await _service.open();
  }

  @override
  Future<CapturedImage> capture() => _service.capture();

  @override
  Future<void> close() async {
    if (_attached) {
      _observer.detach();
      _attached = false;
    }
    await _service.dispose();
  }

  @override
  Widget buildPreview(BuildContext context) => _service.buildPreview();
}
