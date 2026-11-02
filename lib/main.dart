import 'package:flutter/material.dart';

import 'app/bootstrap.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/theme/presentation/cubit/theme_state.dart';
import 'features/theme/presentation/widgets/apply_text_scale.dart';
import 'features/theme/presentation/widgets/theme_variant_builder.dart';

void main() => bootstrap(const BaseerApp());

class BaseerApp extends StatelessWidget {
  const BaseerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeVariantBuilder(
      builder: (context, variant) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appTitle,
        theme: variant == ThemeVariant.highContrast
            ? AppTheme.highContrast
            : AppTheme.standard,
        highContrastTheme: AppTheme.highContrast,
        builder: applyTextScale,
        home: const Scaffold(
          body: Center(child: Text(AppStrings.welcomeMessage)),
        ),
      ),
    );
  }
}
