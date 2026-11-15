import 'coded_enum.dart';

enum HapticPattern implements CodedEnum {
  none('NONE'),
  lightVibration('LIGHT_VIBRATION'),
  strongVibration('STRONG_VIBRATION'),
  unknown('');

  const HapticPattern(this.code);

  @override
  final String code;

  static HapticPattern fromCode(String? code) =>
      enumFromCode(values, code, unknown);
}
