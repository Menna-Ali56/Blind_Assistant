import '../../../../core/errors/handlers/error_handler.dart';
import '../../../../core/errors/result/result.dart';
import '../../../../core/storage/secure_store.dart';
import '../../../../core/storage/secure_store_json.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/app_settings_mapper.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(
    this._store, {
    ErrorHandler errorHandler = const ErrorHandler(),
  }) : _errors = errorHandler;

  static const String storageKey = 'settings.v1';
  static const String _logContext = 'settings_repository';

  final SecureStore _store;
  final ErrorHandler _errors;

  @override
  Future<Result<AppSettings>> load() => _errors.guard(() async {
    final json = await _store.readJson(storageKey);
    return json == null
        ? const AppSettings()
        : AppSettingsMapper.fromJson(json);
  }, context: _logContext);

  @override
  Future<Result<void>> save(AppSettings settings) => _errors.guard(
    () => _store.writeJson(storageKey, AppSettingsMapper.toJson(settings)),
    context: _logContext,
  );

  @override
  Future<Result<void>> deleteAll() =>
      _errors.guard(_store.deleteAll, context: _logContext);
}
