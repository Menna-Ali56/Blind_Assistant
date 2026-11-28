import 'quality_texts.dart';
import 'quality_texts_ar.dart';
import 'quality_texts_en.dart';

QualityTexts qualityTextsFor(String languageCode) =>
    languageCode.toLowerCase().startsWith('ar')
    ? arabicQualityTexts
    : englishQualityTexts;
