import 'package:flutter/widgets.dart';

import '../entities/camera_status.dart';
import '../entities/captured_image.dart';

abstract interface class CameraService {
  CameraStatus get status;

  Future<void> open();

  Future<CapturedImage> capture();

  Future<void> pause();

  Future<void> resume();

  Future<void> dispose();

  Widget buildPreview();
}
