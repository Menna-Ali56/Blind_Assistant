import '../../../../core/navigation/app_destination.dart';

const String _screenSlot = '{screen}';

class NavigationTexts {
  const NavigationTexts({
    required this.screens,
    required this.settings,
    required this.openTemplate,
  });

  final Map<AppDestination, String> screens;
  final String settings;
  final String openTemplate;

  String screenName(AppDestination destination) => screens[destination]!;

  String confirmation(String screen) =>
      openTemplate.replaceAll(_screenSlot, screen);
}
