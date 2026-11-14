import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app/bootstrap.dart';
import 'core/constants/app_strings.dart';
import 'core/di/injector.dart';
import 'core/theme/app_theme.dart';
import 'features/theme/presentation/cubit/theme_state.dart';
import 'features/theme/presentation/widgets/apply_text_scale.dart';
import 'features/theme/presentation/widgets/theme_variant_builder.dart';

Future<void> main() => bootstrap(const BaseerApp());

class BaseerApp extends StatelessWidget {
  const BaseerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeVariantBuilder(
      builder: (context, variant) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appTitle,
        themeMode: variant == ThemeVariant.highContrast
            ? ThemeMode.dark
            : ThemeMode.light,
        highContrastTheme: AppTheme.highContrast,
        builder: applyTextScale,
        routerConfig: sl<GoRouter>(),
      ),
    );
  }
}
