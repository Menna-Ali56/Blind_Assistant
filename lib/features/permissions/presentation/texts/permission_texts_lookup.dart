import 'permission_texts.dart';
import 'permission_texts_ar.dart';
import 'permission_texts_en.dart';

PermissionTexts permissionTextsFor(String languageCode) =>
    languageCode.toLowerCase().startsWith('ar')
    ? arabicPermissionTexts
    : englishPermissionTexts;
