import 'coded_enum.dart';

enum VoiceIntent implements CodedEnum {
  readDocument('READ_DOCUMENT'),
  recognizeCurrency('RECOGNIZE_CURRENCY'),
  indoorNavigation('INDOOR_NAVIGATION'),
  describeScene('DESCRIBE_SCENE'),
  detectColor('DETECT_COLOR'),
  readTrafficSign('READ_TRAFFIC_SIGN'),
  detectObstacle('DETECT_OBSTACLE'),
  detectExpression('DETECT_EXPRESSION'),
  unknown('');

  const VoiceIntent(this.code);

  @override
  final String code;

  static VoiceIntent fromCode(String? code) =>
      enumFromCode(values, code, unknown);
}
