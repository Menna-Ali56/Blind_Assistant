import '../errors/exceptions/contract_exception.dart';

const String _confidenceKey = 'confidence';

Map<String, dynamic> asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  throw const ContractException();
}

T requiredField<T>(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is T) return value;
  throw const ContractException();
}

T? optionalField<T>(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null || value is T) return value as T?;
  throw const ContractException();
}

double requiredNumber(Map<String, dynamic> json, String key) =>
    requiredField<num>(json, key).toDouble();

double? optionalNumber(Map<String, dynamic> json, String key) =>
    optionalField<num>(json, key)?.toDouble();

double readConfidence(Map<String, dynamic> json) =>
    requiredNumber(json, _confidenceKey);

List<String> requiredStrings(Map<String, dynamic> json, String key) {
  final items = requiredField<List<dynamic>>(json, key);
  if (items.every((item) => item is String)) return items.cast<String>();
  throw const ContractException();
}
