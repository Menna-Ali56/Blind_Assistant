import 'dart:typed_data';

import 'package:flutter/widgets.dart';

abstract interface class CameraDriver {
  Future<void> open();

  Future<Uint8List> takePicture();

  Future<void> close();

  Widget buildPreview();
}
