import 'package:camera/camera.dart';

abstract final class CameraDefaults {
  static const ResolutionPreset resolution = ResolutionPreset.high;
  static const CameraLensDirection lens = CameraLensDirection.back;
  static const ImageFormatGroup imageFormat = ImageFormatGroup.jpeg;
  static const bool enableAudio = false;
}
