import 'package:equatable/equatable.dart';

import '../utils/json_fields.dart';

class ColorResult extends Equatable {
  const ColorResult({
    required this.colorNameArabic,
    required this.colorNameEnglish,
    required this.hexCode,
    required this.disclaimer,
    required this.confidence,
  });

  factory ColorResult.fromJson(Map<String, dynamic> json) => ColorResult(
    colorNameArabic: requiredField<String>(json, 'colorNameArabic'),
    colorNameEnglish: requiredField<String>(json, 'colorNameEnglish'),
    hexCode: requiredField<String>(json, 'hexCode'),
    disclaimer: requiredField<String>(json, 'disclaimer'),
    confidence: readConfidence(json),
  );

  final String colorNameArabic;
  final String colorNameEnglish;
  final String hexCode;
  final String disclaimer;
  final double confidence;

  @override
  List<Object?> get props => [
    colorNameArabic,
    colorNameEnglish,
    hexCode,
    disclaimer,
    confidence,
  ];
}
