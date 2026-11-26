import '../../../../core/navigation/app_destination.dart';
import 'navigation_texts.dart';

const NavigationTexts englishNavigationTexts = NavigationTexts(
  screens: {
    AppDestination.home: 'home',
    AppDestination.read: 'reading',
    AppDestination.detect: 'detection',
    AppDestination.assistant: 'the assistant',
  },
  settings: 'settings',
  openTemplate: 'Opening {screen}',
);
