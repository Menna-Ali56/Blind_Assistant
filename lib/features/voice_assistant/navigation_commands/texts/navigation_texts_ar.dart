import '../../../../core/navigation/app_destination.dart';
import 'navigation_texts.dart';

const NavigationTexts arabicNavigationTexts = NavigationTexts(
  screens: {
    AppDestination.home: 'الرئيسية',
    AppDestination.read: 'القراءة',
    AppDestination.detect: 'الكشف',
    AppDestination.assistant: 'المساعد',
  },
  settings: 'الإعدادات',
  openTemplate: 'جارٍ فتح {screen}',
);
