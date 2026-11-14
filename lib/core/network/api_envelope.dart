import 'package:equatable/equatable.dart';

import '../utils/json_fields.dart';
import 'api_config.dart';

class ApiMeta extends Equatable {
  const ApiMeta({this.modelName, this.modelVersion, this.processingTimeMs});

  factory ApiMeta.fromJson(Map<String, dynamic> json) => ApiMeta(
    modelName: optionalField<String>(json, ApiKeys.modelName),
    modelVersion: optionalField<String>(json, ApiKeys.modelVersion),
    processingTimeMs: optionalNumber(json, ApiKeys.processingTimeMs),
  );

  final String? modelName;
  final String? modelVersion;
  final double? processingTimeMs;

  @override
  List<Object?> get props => [modelName, modelVersion, processingTimeMs];
}

class ApiSuccess<T> {
  const ApiSuccess({required this.data, this.requestId, this.meta});

  final T data;
  final String? requestId;
  final ApiMeta? meta;
}

ApiSuccess<T> parseSuccess<T>(
  Object? json,
  T Function(Map<String, dynamic> data) fromData,
) {
  final body = asJsonMap(json);
  final meta = optionalField<Map<String, dynamic>>(body, ApiKeys.meta);
  return ApiSuccess(
    data: fromData(requiredField<Map<String, dynamic>>(body, ApiKeys.data)),
    requestId: optionalField<String>(body, ApiKeys.requestId),
    meta: meta == null ? null : ApiMeta.fromJson(meta),
  );
}
