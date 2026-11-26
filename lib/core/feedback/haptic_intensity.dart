import '../inference/coded_enum.dart';

enum HapticIntensity implements CodedEnum {
  low('low', 80),
  medium('medium', 160),
  high('high', 255);

  const HapticIntensity(this.code, this.amplitude);

  @override
  final String code;

  final int amplitude;

  static const int maxAmplitude = 255;

  static HapticIntensity fromCode(String? code) =>
      enumFromCode(values, code, medium);
}
