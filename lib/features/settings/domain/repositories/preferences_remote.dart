import '../../../../core/errors/result/result.dart';
import '../entities/app_settings.dart';

abstract interface class PreferencesRemote {
  Future<Result<void>> save(AppSettings settings);
}

class NoPreferencesRemote implements PreferencesRemote {
  const NoPreferencesRemote();

  @override
  Future<Result<void>> save(AppSettings settings) async =>
      const ResultSuccess<void>(null);
}
