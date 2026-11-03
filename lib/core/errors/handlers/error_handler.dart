import '../failures/failure.dart';
import '../mappers/exception_to_failure_mapper.dart';
import '../result/result.dart';
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

  /// Runs [action] and never throws: errors become a ResultFailure.
  Future<Result<T>> guard<T>(
      Future<T> Function() action, {
        String? context,
      }) async {
    try {
      return ResultSuccess(await action());
    } catch (e, st) {
      return ResultFailure(handle(e, st, context: context));
    }
  }

  /// Synchronous version of [guard].
  Result<T> guardSync<T>(T Function() action, {String? context}) {
    try {
      return ResultSuccess(action());
    } catch (e, st) {
      return ResultFailure(handle(e, st, context: context));
    }
  }
}