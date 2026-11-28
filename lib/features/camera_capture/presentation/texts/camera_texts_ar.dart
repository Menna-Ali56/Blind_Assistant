import '../cubit/camera_stage.dart';
import 'camera_texts.dart';

const CameraTexts arabicCameraTexts = CameraTexts(
  title: 'الكاميرا',
  previewLabel: 'عرض الكاميرا',
  reviewLabel: 'الصورة الملتقطة',
  captureAction: 'التقاط صورة',
  retakeAction: 'إعادة الالتقاط',
  useAction: 'استخدام الصورة',
  retryAction: 'حاول مرة أخرى',
  messages: {
    CameraStage.opening: 'جارٍ فتح الكاميرا.',
    CameraStage.ready:
        'الكاميرا جاهزة. أمسك الهاتف بثبات ووجّهه نحو النص. '
        'ثم اضغط على زر التقاط صورة.',
    CameraStage.capturing: 'جارٍ التقاط الصورة. ابقَ ثابتًا.',
    CameraStage.review:
        'تم التقاط الصورة. اضغط على استخدام الصورة للمتابعة '
        'أو إعادة الالتقاط للمحاولة مرة أخرى.',
    CameraStage.accepted: 'جارٍ استخدام هذه الصورة.',
    CameraStage.openFailed: 'تعذّر تشغيل الكاميرا. اضغط على حاول مرة أخرى.',
    CameraStage.captureFailed: 'تعذّر التقاط الصورة. اضغط على حاول مرة أخرى.',
  },
);
