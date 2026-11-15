import 'package:equatable/equatable.dart';

import '../utils/json_fields.dart';

class CurrencyResult extends Equatable {
  const CurrencyResult({
    required this.denomination,
    required this.currency,
    required this.spokenAnnouncement,
    required this.condition,
    required this.confidence,
  });

  factory CurrencyResult.fromJson(Map<String, dynamic> json) => CurrencyResult(
    denomination: requiredField<int>(json, 'denomination'),
    currency: requiredField<String>(json, 'currency'),
    spokenAnnouncement: requiredField<String>(json, 'spokenAnnouncement'),
    condition: requiredField<String>(json, 'condition'),
    confidence: readConfidence(json),
  );

  final int denomination;
  final String currency;
  final String spokenAnnouncement;
  final String condition;
  final double confidence;

  @override
  List<Object?> get props => [
    denomination,
    currency,
    spokenAnnouncement,
    condition,
    confidence,
  ];
}
