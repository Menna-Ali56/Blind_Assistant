import 'package:equatable/equatable.dart';

import '../utils/json_fields.dart';
import 'facial_expression.dart';

class FaceExpressionResult extends Equatable {
  const FaceExpressionResult({
    required this.expression,
    required this.spokenDescription,
    required this.confidence,
  });

  factory FaceExpressionResult.fromJson(Map<String, dynamic> json) =>
      FaceExpressionResult(
        expression: FacialExpression.fromCode(
          optionalField<String>(json, 'expression'),
        ),
        spokenDescription: requiredField<String>(json, 'spokenDescription'),
        confidence: readConfidence(json),
      );

  final FacialExpression expression;
  final String spokenDescription;
  final double confidence;

  @override
  List<Object?> get props => [expression, spokenDescription, confidence];
}
