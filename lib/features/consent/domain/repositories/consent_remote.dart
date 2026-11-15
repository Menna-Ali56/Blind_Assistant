import '../../../../core/errors/result/result.dart';
import '../entities/consent_record.dart';

abstract interface class ConsentRemote {
  Future<Result<void>> save(ConsentRecord record);
}

class NoConsentRemote implements ConsentRemote {
  const NoConsentRemote();

  @override
  Future<Result<void>> save(ConsentRecord record) async =>
      const ResultSuccess<void>(null);
}
