import 'settings_command_texts.dart';
import 'settings_command_texts_ar.dart';
import 'settings_command_texts_en.dart';

SettingsCommandTexts settingsCommandTextsFor(String languageCode) =>
    languageCode.toLowerCase().startsWith('ar')
    ? arabicSettingsCommandTexts
    : englishSettingsCommandTexts;
