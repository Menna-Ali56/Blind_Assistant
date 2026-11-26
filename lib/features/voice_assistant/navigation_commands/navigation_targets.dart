import '../../../core/navigation/app_destination.dart';
import '../../settings/settings_route.dart';
import 'navigation_command_ids.dart';
import 'texts/navigation_texts.dart';

class NavigationTarget {
  const NavigationTarget({
    required this.id,
    required this.path,
    required this.screenName,
  });

  final String id;
  final String path;
  final String Function(NavigationTexts texts) screenName;
}

final List<NavigationTarget> navigationTargets = [
  for (final destination in AppDestination.values)
    NavigationTarget(
      id: openCommandId(destination.name),
      path: destination.path,
      screenName: (texts) => texts.screenName(destination),
    ),
  NavigationTarget(
    id: openCommandId(settingsCommandName),
    path: settingsPath,
    screenName: (texts) => texts.settings,
  ),
];
