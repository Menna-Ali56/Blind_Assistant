import '../failures/failure.dart';

/// Temporary fallback strings. Connect these keys to app localization later.
class ErrorMessageMapper {
  const ErrorMessageMapper();

  String map(Failure failure, {required String languageCode}) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');
    final messages = isArabic
        ? const <String, String>{
      'network_error': 'لا يوجد اتصال بالإنترنت. يُرجى التحقق من الاتصال والمحاولة مرة أخرى.',
      'server_error': 'حدثت مشكلة في الخادم. يُرجى المحاولة مرة أخرى.',
      'timeout_error': 'استغرق الطلب وقتًا أطول من المتوقع. يُرجى المحاولة مرة أخرى.',
      'permission_denied': 'يُرجى السماح بالوصول إلى الصلاحية المطلوبة للمتابعة.',
      'camera_unavailable': 'الكاميرا غير متاحة حاليًا.',
      'microphone_unavailable': 'الميكروفون غير متاح حاليًا.',
      'storage_error': 'حدثت مشكلة أثناء حفظ البيانات.',
      'model_error': 'حدثت مشكلة أثناء تشغيل نموذج الذكاء الاصطناعي.',
      'ocr_error': 'تعذّر التعرّف على النص الموجود في الصورة.',
      'speech_error': 'حدثت مشكلة أثناء معالجة الكلام.',
      'unexpected_error': 'حدث خطأ غير متوقع. يُرجى المحاولة مرة أخرى.',
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
