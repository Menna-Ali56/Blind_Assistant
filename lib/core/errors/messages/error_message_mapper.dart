import '../failures/failure.dart';

/// Temporary fallback strings. Connect these keys to app localization later.
class ErrorMessageMapper {
  const ErrorMessageMapper();

  String map(Failure failure, {required String languageCode}) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');
    final messages = isArabic
        ? const <String, String>{
            'network_error': 'مفيش اتصال بالإنترنت. اتأكد من الاتصال وحاول تاني',
            'server_error': 'حصلت مشكلة في الخادم. حاول مرة تانية',
            'timeout_error': 'الطلب استغرق وقت طويل. حاول تاني',
            'permission_denied': 'لازم تسمح بالصلاحية المطلوبة عشان تكمل',
            'camera_unavailable': 'الكاميرا مش متاحة حاليًا',
            'microphone_unavailable': 'الميكروفون مش متاح حاليًا',
            'storage_error': 'حصلت مشكلة أثناء حفظ البيانات',
            'model_error': 'حصلت مشكلة أثناء تشغيل نموذج الذكاء الاصطناعي',
            'ocr_error': 'مش قادر أتعرف على النص من الصورة',
            'speech_error': 'حصلت مشكلة في معالجة الكلام',
            'unexpected_error': 'حصل خطأ غير متوقع. حاول مرة تانية',
          }
        : const <String, String>{
            'network_error': 'No internet connection. Check your connection and try again.',
            'server_error': 'The server encountered a problem. Please try again.',
            'timeout_error': 'The request took too long. Please try again.',
            'permission_denied': 'The required permission was not granted.',
            'camera_unavailable': 'The camera is currently unavailable.',
            'microphone_unavailable': 'The microphone is currently unavailable.',
            'storage_error': 'Something went wrong while saving data.',
            'model_error': 'The AI model could not complete the operation.',
            'ocr_error': 'Text could not be recognized from the image.',
            'speech_error': 'Something went wrong while processing speech.',
            'unexpected_error': 'An unexpected error occurred. Please try again.',
          };

    return messages[failure.messageKey] ?? messages['unexpected_error']!;
  }
}
