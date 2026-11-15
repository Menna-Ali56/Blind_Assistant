import 'package:equatable/equatable.dart';

import '../utils/json_fields.dart';

class OcrResult extends Equatable {
  const OcrResult({
    required this.detectedLanguage,
    required this.extractedText,
    required this.arabicSimplifiedText,
    required this.confidence,
  });

  factory OcrResult.fromJson(Map<String, dynamic> json) => OcrResult(
    detectedLanguage: requiredField<String>(json, 'detectedLanguage'),
    extractedText: requiredField<String>(json, 'extractedText'),
    arabicSimplifiedText: requiredField<String>(json, 'arabicSimplifiedText'),
    confidence: readConfidence(json),
  );

  final String detectedLanguage;
  final String extractedText;
  final String arabicSimplifiedText;
  final double confidence;

  @override
  List<Object?> get props => [
    detectedLanguage,
    extractedText,
    arabicSimplifiedText,
    confidence,
  ];
}
