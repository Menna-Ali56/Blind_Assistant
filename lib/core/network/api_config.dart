abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL');
  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration sendTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

abstract final class ApiHeaders {
  static const String clientTaskId = 'X-Client-Task-Id';
  static const String clientTaskIdExtra = 'clientTaskId';
}

abstract final class ApiKeys {
  static const String success = 'success';
  static const String errorCode = 'errorCode';
  static const String requestId = 'requestId';
  static const String data = 'data';
  static const String meta = 'meta';
  static const String modelName = 'modelName';
  static const String modelVersion = 'modelVersion';
  static const String processingTimeMs = 'processingTimeMs';
}
