import 'package:dio/dio.dart';

import '../exceptions/app_exception.dart';
import '../failures/failures.dart';

class DioFailureMapper {
  const DioFailureMapper();

  Failure map(DioException error, Failure Function(Object) mapInner) {
    final inner = error.error;
    if (inner is Failure || inner is AppException) return mapInner(inner!);
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const TimeoutFailure(),
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => const NetworkFailure(),
      DioExceptionType.badResponse => ServerFailure(
        statusCode: error.response?.statusCode,
      ),
      DioExceptionType.cancel => const CancelledFailure(),
      _ => inner == null ? const UnknownFailure() : mapInner(inner),
    };
  }
}
