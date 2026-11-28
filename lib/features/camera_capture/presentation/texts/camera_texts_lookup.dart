import 'camera_texts.dart';
import 'camera_texts_ar.dart';
import 'camera_texts_en.dart';

CameraTexts cameraTextsFor(String languageCode) =>
    languageCode.toLowerCase().startsWith('ar')
    ? arabicCameraTexts
    : englishCameraTexts;
