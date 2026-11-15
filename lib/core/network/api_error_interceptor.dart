import 'package:dio/dio.dart';

import '../errors/failures/api_failure.dart';
import 'api_config.dart';

class ApiErrorInterceptor extends Interceptor {
  const ApiErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _failureFrom(err.response);
    if (failure == null) {
      handler.next(err);
      return;
    }
    handler.next(err.copyWith(error: failure));
  }

  ApiFailure? _failureFrom(Response<dynamic>? response) {
    final body = response?.data;
    if (body is! Map<String, dynamic>) return null;
    final code = body[ApiKeys.errorCode];
    if (body[ApiKeys.success] != false || code is! String) return null;
    final requestId = body[ApiKeys.requestId];
    return ApiFailure.fromCode(
      code,
      statusCode: response?.statusCode,
      requestId: requestId is String ? requestId : null,
    );
  }
}
