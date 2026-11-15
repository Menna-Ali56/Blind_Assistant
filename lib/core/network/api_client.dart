import 'package:dio/dio.dart';

import '../tasks/task_id_generator.dart';
import 'api_config.dart';
import 'api_error_interceptor.dart';
import 'request_ids_interceptor.dart';

Dio buildApiClient({required String baseUrl, required TaskIdGenerator ids}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      contentType: Headers.jsonContentType,
    ),
  );
  dio.interceptors.addAll([
    RequestIdsInterceptor(ids),
    const ApiErrorInterceptor(),
  ]);
  return dio;
}
