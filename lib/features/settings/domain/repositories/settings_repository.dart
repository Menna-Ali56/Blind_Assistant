import '../../../../core/errors/result/result.dart';
import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  /// Defaults when nothing was saved yet or the saved data is damaged.
  Future<Result<AppSettings>> load();

  Future<Result<void>> save(AppSettings settings);

  /// Removes everything stored on the device (the "delete my data" action).
  Future<Result<void>> deleteAll();
}
