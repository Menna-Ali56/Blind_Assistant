import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/home_quick_action.dart';
import '../texts/home_texts.dart';
import '../widgets/assistant_hero_card.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/quick_actions_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final columns = scale >= HomeDimens.singleColumnScale
        ? 1
        : HomeDimens.gridColumns;

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: AppStrings.welcomeMessage,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppDimens.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HomeHeader(),
                const SizedBox(height: HomeDimens.sectionGap),
                const AssistantHeroCard(),
                const SizedBox(height: HomeDimens.sectionGap),
                const QuickActionsHeader(),
                const SizedBox(height: AppDimens.itemGap),
                _QuickActionsGrid(columns: columns),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) {
    if (columns == 1) {
      return Column(
        children: [
          for (var i = 0; i < homeQuickActions.length; i++) ...[
            if (i > 0) const SizedBox(height: HomeDimens.gridSpacing),
            QuickActionCard(action: homeQuickActions[i]),
          ],
        ],
      );
    }

    return Column(
      children: [
        for (var i = 0; i < homeQuickActions.length; i += columns) ...[
          if (i > 0) const SizedBox(height: HomeDimens.gridSpacing),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var j = 0; j < columns; j++) ...[
                  if (j > 0) const SizedBox(width: HomeDimens.gridSpacing),
                  Expanded(
                    child: i + j < homeQuickActions.length
                        ? QuickActionCard(action: homeQuickActions[i + j])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
