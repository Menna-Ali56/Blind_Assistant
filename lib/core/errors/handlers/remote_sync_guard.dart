import '../failures/failure.dart';
import '../result/result.dart';
import 'error_logger.dart';

Future<void> runRemoteSync(
  Future<Result<void>> Function() action, {
  required String context,
  ErrorLogger logger = const ErrorLogger(),
}) async {
  try {
    final result = await action();
    result.fold(
      onSuccess: (_) {},
      onFailure: (Failure failure) => logger.log(
        failure,
        StackTrace.current,
        context: context,
        code: failure.code,
        fields: failure.logFields,
      ),
    );
  } catch (error, stackTrace) {
    logger.log(error, stackTrace, context: context);
  }
}
