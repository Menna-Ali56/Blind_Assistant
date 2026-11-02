import '../../../../core/constants/app_defaults.dart';
import '../../../../core/cubit/base_cubit.dart';
import 'theme_state.dart';

class ThemeCubit extends BaseCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void selectVariant(ThemeVariant variant) {
    safeEmit(state.copyWith(variant: variant));
  }

  void toggleHighContrast() {
    selectVariant(
      state.isHighContrast ? ThemeVariant.standard : ThemeVariant.highContrast,
    );
  }

  void changeTextScale(double value) {
    final limited = value.clamp(
      AppDefaults.minTextScale,
      AppDefaults.maxTextScale,
    );
    safeEmit(state.copyWith(textScale: limited.toDouble()));
  }
}
