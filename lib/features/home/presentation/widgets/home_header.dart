import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../settings/settings_route.dart';
import '../texts/home_texts.dart';
import 'home_palette.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    void openSettings() => context.push(settingsPath);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HomeTexts.greetingEyebrow,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: HomeDimens.eyebrowTracking,
                ),
              ),
              const SizedBox(height: HomeDimens.tinyGap),
              Text(
                HomeTexts.greetingTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ).asHeader().asLiveRegion(),
            ],
          ),
        ),
        const SizedBox(width: AppDimens.itemGap),
        Material(
          color: HomePalette.heroBackground(scheme),
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
          child: InkWell(
            onTap: openSettings,
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
            child: Container(
              width: HomeDimens.badgeSize,
              height: HomeDimens.badgeSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                border: Border.all(
                  color: scheme.outlineVariant,
                  width: AppDimens.hairline,
                ),
              ),
              child: Text(
                HomeTexts.profileBadge,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: HomePalette.heroTitleColor(scheme),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ).asButton(
          label: AppStrings.settingsLabel,
          hint: AppStrings.settingsHint,
          onTap: openSettings,
        ),
      ],
    );
  }
}
