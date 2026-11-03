import 'failure.dart';

class ServerFailure extends Failure {
  const ServerFailure({this.statusCode})
      : super(
    messageKey: statusCode == 401
        ? 'unauthorized'
        : statusCode == 403
        ? 'forbidden'
        : statusCode == 404
        ? 'not_found'
        : statusCode == 429
        ? 'too_many_requests'
        : 'server_error',
    code: 'server',
    // Retry only helps for server-side / temporary problems.
    isRetryable: statusCode == null ||
        statusCode >= 500 ||
        statusCode == 408 ||
        statusCode == 429,
  );

  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];
}