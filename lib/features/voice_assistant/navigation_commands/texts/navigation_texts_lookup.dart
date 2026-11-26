import 'navigation_texts.dart';
import 'navigation_texts_ar.dart';
import 'navigation_texts_en.dart';

NavigationTexts navigationTextsFor(String languageCode) =>
    languageCode.toLowerCase().startsWith('ar')
    ? arabicNavigationTexts
    : englishNavigationTexts;
