import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/navigation/app_destination.dart';
import '../../../../core/widgets/screen_scaffold.dart';
import '../widgets/destination_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final shortcuts = AppDestination.shortcuts;
    return ScreenScaffold(
      title: AppStrings.welcomeMessage,
      child: ListView.separated(
        padding: AppDimens.pagePadding,
        itemCount: shortcuts.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimens.itemGap),
        itemBuilder: (context, index) =>
            DestinationButton(destination: shortcuts[index]),
      ),
    );
  }
}
