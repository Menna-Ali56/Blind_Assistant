import 'package:flutter/widgets.dart';

import '../../../camera/domain/entities/captured_image.dart';

/// port for the device camera implemented in the data layer
abstract interface class CameraSession {
  Future<void> open();

  Future<CapturedImage> capture();

  Future<void> close();

  Widget buildPreview(BuildContext context);
}
