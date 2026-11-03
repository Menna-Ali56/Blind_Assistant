import '../failures/failure.dart';
import '../mappers/exception_to_failure_mapper.dart';
import 'error_logger.dart';

class ErrorHandler {
  const ErrorHandler({
    this.mapper = const ExceptionToFailureMapper(),
    this.logger = const ErrorLogger(),
  });

  final ExceptionToFailureMapper mapper;
  final ErrorLogger logger;

  Failure handle(
    Object error,
    StackTrace stackTrace, {
    String? context,
  }) {
    final failure = mapper.map(error);
    logger.log(error, stackTrace, context: context, code: failure.code);
    return failure;
  }
}
