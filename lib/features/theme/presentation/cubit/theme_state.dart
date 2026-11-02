import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_defaults.dart';

enum ThemeVariant { standard, highContrast }

class ThemeState extends Equatable {
  const ThemeState({
    this.variant = ThemeVariant.standard,
    this.textScale = AppDefaults.textScale,
  });

  final ThemeVariant variant;
  final double textScale;

  bool get isHighContrast => variant == ThemeVariant.highContrast;

  ThemeState copyWith({ThemeVariant? variant, double? textScale}) {
    return ThemeState(
      variant: variant ?? this.variant,
      textScale: textScale ?? this.textScale,
    );
  }

  @override
  List<Object> get props => [variant, textScale];
}
