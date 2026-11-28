import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

import '../../../core/errors/exceptions/camera_exception.dart';
import 'camera_defaults.dart';
import 'camera_driver.dart';
import 'camera_error_codes.dart';
import 'camera_error_mapper.dart';

class PackageCameraDriver implements CameraDriver {
  PackageCameraDriver({this.listCameras = availableCameras});

  final Future<List<CameraDescription>> Function() listCameras;
  CameraController? _controller;

  @override
  Future<void> open() => CameraErrorMapper.guard(() async {
    final description = await _pick();
    final controller = CameraController(
      description,
      CameraDefaults.resolution,
      enableAudio: CameraDefaults.enableAudio,
      imageFormatGroup: CameraDefaults.imageFormat,
    );
    try {
      await controller.initialize();
    } catch (_) {
      await controller.dispose();
      rethrow;
    }
    _controller = controller;
  });

  @override
  Future<Uint8List> takePicture() => CameraErrorMapper.guard(() async {
    final file = await _ready.takePicture();
    try {
      return await file.readAsBytes();
    } finally {
      await _discard(file.path);
    }
  });

  @override
  Future<void> close() async {
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }

  @override
  Widget buildPreview() {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();
    return CameraPreview(controller);
  }

  CameraController get _ready {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw const AppCameraException(code: CameraErrorCodes.notReady);
    }
    return controller;
  }

  Future<CameraDescription> _pick() async {
    final cameras = await listCameras();
    if (cameras.isEmpty) {
      throw const AppCameraException(code: CameraErrorCodes.noCamera);
    }
    return cameras.firstWhere(
      (camera) => camera.lensDirection == CameraDefaults.lens,
      orElse: () => cameras.first,
    );
  }

  // the temp file is deleted so no image stays on disk
  Future<void> _discard(String path) async {
    try {
      await File(path).delete();
    } on FileSystemException {
      return;
    }
  }
}
