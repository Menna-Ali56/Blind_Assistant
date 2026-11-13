import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/navigation/app_destination.dart';
import '../../../../core/widgets/screen_scaffold.dart';
import '../widgets/destination_button.dart';
import '../../../../core/accessibility/semantics_extension.dart';
import '../../../settings/settings_route.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final shortcuts = AppDestination.shortcuts;
    return ScreenScaffold(
      title: AppStrings.welcomeMessage,
      child: ListView.separated(
        padding: AppDimens.pagePadding,
        itemCount: shortcuts.length+1,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimens.itemGap),
        itemBuilder: (context, index) {
          if (index < shortcuts.length) {
            return DestinationButton(destination: shortcuts[index]);
          }

          void open() => context.push(settingsPath);
          return FilledButton.icon(
            onPressed: open,
            icon: const Icon(Icons.settings_outlined),
            label: const Text(AppStrings.settingsLabel),
          ).asButton(
            label: AppStrings.settingsLabel,
            hint: AppStrings.settingsHint,
            onTap: open,
          );
        },
      ),
    );
  }
}
