import '../../../../core/errors/result/result.dart';
import '../entities/consent_record.dart';

abstract interface class ConsentRepository {
  Future<Result<ConsentRecord>> load();

  Future<Result<void>> save(ConsentRecord record);

  Future<Result<void>> clear();
}
