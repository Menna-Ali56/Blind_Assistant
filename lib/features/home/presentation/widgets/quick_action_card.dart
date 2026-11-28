import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/home_quick_action.dart';
import '../texts/home_texts.dart';
import 'home_palette.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.action});

  final HomeQuickAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tone = HomePalette.toneOf(action.tone, scheme);
    void open() => context.go(action.destination.path);

    return Material(
      color: scheme.surfaceContainer,
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: InkWell(
        onTap: open,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Container(
          padding: HomeDimens.cardPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radius),
            border: Border.all(
              color: scheme.outlineVariant,
              width: AppDimens.hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: HomeDimens.cardIconBox,
                    height: HomeDimens.cardIconBox,
                    decoration: BoxDecoration(
                      color: tone.background,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusSmall,
                      ),
                    ),
                    child: Icon(
                      action.icon,
                      size: HomeDimens.iconSize,
                      color: tone.foreground,
                    ).decorative(),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: HomeDimens.arrowSize,
                    color: scheme.onSurfaceVariant,
                  ).decorative(),
                ],
              ),
              const SizedBox(height: HomeDimens.cardTitleTopGap),
              Text(
                action.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: HomeDimens.smallGap),
              Text(
                action.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    ).asButton(
      label: '${action.title}. ${action.subtitle}',
      hint: action.destination.hint,
      onTap: open,
    );
  }
}
