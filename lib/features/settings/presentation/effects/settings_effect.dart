import '../../domain/entities/app_settings.dart';

abstract interface class SettingsEffect {
  void apply(AppSettings settings);
}
