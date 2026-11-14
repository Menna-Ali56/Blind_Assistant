abstract interface class CodedEnum {
  String get code;
}

T enumFromCode<T extends CodedEnum>(List<T> values, String? code, T fallback) {
  for (final value in values) {
    if (value.code == code) return value;
  }
  return fallback;
}
