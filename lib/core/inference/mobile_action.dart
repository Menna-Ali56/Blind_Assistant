import 'coded_enum.dart';

enum MobileAction implements CodedEnum {
  openCameraOcr('OPEN_CAMERA_OCR'),
  openCameraCurrency('OPEN_CAMERA_CURRENCY'),
  openCameraQr('OPEN_CAMERA_QR'),
  openCameraDescribe('OPEN_CAMERA_DESCRIBE'),
  openCameraColor('OPEN_CAMERA_COLOR'),
  openCameraTrafficSign('OPEN_CAMERA_TRAFFIC_SIGN'),
  openCameraObstacle('OPEN_CAMERA_OBSTACLE'),
  openCameraExpression('OPEN_CAMERA_EXPRESSION'),
  unknown('');

  const MobileAction(this.code);

  @override
  final String code;

  static MobileAction fromCode(String? code) =>
      enumFromCode(values, code, unknown);
}
