import '../../../../core/errors/handlers/error_handler.dart';
import '../../../../core/errors/result/result.dart';
import '../../../../core/storage/secure_store.dart';
import '../../../../core/storage/secure_store_json.dart';
import '../../domain/entities/consent_record.dart';
import '../../domain/repositories/consent_repository.dart';
import '../models/consent_record_mapper.dart';

class ConsentRepositoryImpl implements ConsentRepository {
  const ConsentRepositoryImpl(
    this._store, {
    ErrorHandler errorHandler = const ErrorHandler(),
  }) : _errors = errorHandler;

  static const String storageKey = 'consent.v1';
  static const String _logContext = 'consent_repository';

  final SecureStore _store;
  final ErrorHandler _errors;

  @override
  Future<Result<ConsentRecord>> load() => _errors.guard(() async {
    final json = await _store.readJson(storageKey);
    return json == null
        ? const ConsentRecord()
        : ConsentRecordMapper.fromJson(json);
  }, context: _logContext);

  @override
  Future<Result<void>> save(ConsentRecord record) => _errors.guard(
    () => _store.writeJson(storageKey, ConsentRecordMapper.toJson(record)),
    context: _logContext,
  );

  @override
  Future<Result<void>> clear() =>
      _errors.guard(() => _store.delete(storageKey), context: _logContext);
}
