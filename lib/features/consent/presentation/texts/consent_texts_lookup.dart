import '../../../../core/constants/app_languages.dart';
import 'consent_texts.dart';
import 'consent_texts_ar.dart';
import 'consent_texts_en.dart';

ConsentTexts consentTextsFor(String languageCode) =>
    languageCode.toLowerCase().startsWith(AppLanguages.arabic)
    ? arabicConsentTexts
    : englishConsentTexts;
