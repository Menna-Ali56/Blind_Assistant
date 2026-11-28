import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/navigation/app_destination.dart';
import '../texts/home_texts.dart';

class QuickActionsHeader extends StatelessWidget {
  const QuickActionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    void openRecent() => context.go(AppDestination.read.path);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HomeTexts.quickActionsEyebrow,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: HomeDimens.eyebrowTracking,
                ),
              ),
              const SizedBox(height: HomeDimens.tinyGap),
              Text(
                HomeTexts.quickActionsTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ).asHeader(),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppDimens.minTouch,
            minHeight: AppDimens.minTouch,
          ),
          child: TextButton(
            onPressed: openRecent,
            child: const Text(HomeTexts.recentLabel),
          ),
        ).asButton(
          label: HomeTexts.recentLabel,
          hint: HomeTexts.recentHint,
          onTap: openRecent,
        ),
      ],
    );
  }
}
