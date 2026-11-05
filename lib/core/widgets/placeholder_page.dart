import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../constants/app_strings.dart';
import '../navigation/app_destination.dart';
import 'screen_scaffold.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.destination});

  final AppDestination destination;

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: destination.label,
      child: Center(
        child: Padding(
          padding: AppDimens.pagePadding,
          child: Text(
            '${destination.hint}\n${AppStrings.comingSoon}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
