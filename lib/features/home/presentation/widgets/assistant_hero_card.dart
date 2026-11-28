import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/navigation/app_destination.dart';
import '../texts/home_texts.dart';
import 'home_palette.dart';

class AssistantHeroCard extends StatelessWidget {
  const AssistantHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    void open() => context.go(AppDestination.assistant.path);

    return Material(
      color: HomePalette.heroBackground(scheme),
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: InkWell(
        onTap: open,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Container(
          padding: HomeDimens.heroPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radius),
            border: Border.all(
              color: scheme.outlineVariant,
              width: AppDimens.hairline,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: HomeDimens.heroIconBox,
                height: HomeDimens.heroIconBox,
                decoration: BoxDecoration(
                  color: HomePalette.heroIconBox(scheme),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                ),
                child: Icon(
                  Icons.mic_none_outlined,
                  size: HomeDimens.iconSize,
                  color: HomePalette.heroIconColor(scheme),
                ).decorative(),
              ),
              const SizedBox(width: AppDimens.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HomeTexts.assistantTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: HomePalette.heroTitleColor(scheme),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: HomeDimens.tinyGap),
                    Text(
                      HomeTexts.assistantSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: HomePalette.heroSubtitleColor(scheme),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: HomeDimens.smallGap),
              Icon(
                Icons.chevron_right,
                color: HomePalette.heroTitleColor(scheme),
              ).decorative(),
            ],
          ),
        ),
      ),
    ).asButton(
      label: '${HomeTexts.assistantTitle}. ${HomeTexts.assistantSubtitle}',
      hint: AppDestination.assistant.hint,
      onTap: open,
    );
  }
}
