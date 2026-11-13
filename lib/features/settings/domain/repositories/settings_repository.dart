import '../../../../core/errors/result/result.dart';
import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<Result<AppSettings>> load();

  Future<Result<void>> save(AppSettings settings);

  Future<Result<void>> deleteAll();
}
