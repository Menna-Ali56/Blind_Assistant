import 'failure.dart';

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    this.statusCode,
  }) : super(
    messageKey: 'server_error',
    code: 'server',
    isRetryable: true,
  );

  @override
  List<Object?> get props => [
    ...super.props,
    statusCode,
  ];
}