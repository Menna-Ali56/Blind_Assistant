import 'package:dio/dio.dart';

import '../tasks/task_id_generator.dart';
import 'api_config.dart';

class RequestIdsInterceptor extends Interceptor {
  RequestIdsInterceptor(this._ids);

  final TaskIdGenerator _ids;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final given = options.extra[ApiHeaders.clientTaskIdExtra];
    options.headers[ApiHeaders.clientTaskId] = given is String
        ? given
        : _ids.next();
    handler.next(options);
  }
}
