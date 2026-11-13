import '../../../theme/presentation/cubit/theme_cubit.dart';
import '../../../theme/presentation/cubit/theme_state.dart';
import '../../domain/entities/app_settings.dart';
import 'settings_effect.dart';

class ThemeSettingsEffect implements SettingsEffect {
  const ThemeSettingsEffect(this._theme);

  final ThemeCubit _theme;

  @override
  void apply(AppSettings settings) {
    _theme
      ..selectVariant(
        settings.highContrast
            ? ThemeVariant.highContrast
            : ThemeVariant.standard,
      )
      ..changeTextScale(settings.textScale);
  }
}
