import '../failures/failure.dart';
import '../failures/permission_failure.dart';

/// Temporary fallback strings. Connect these keys to app localization later.
class ErrorMessageMapper {
  const ErrorMessageMapper();

  String map(Failure failure, {required String languageCode}) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    if (failure is PermissionFailure) {
      return _permissionMessage(failure, isArabic);
    }

    final messages = isArabic
        ? const <String, String>{
            'network_error':
                'لا يوجد اتصال بالإنترنت. يُرجى التحقق من الاتصال والمحاولة مرة أخرى.',
            'server_error': 'حدثت مشكلة في الخادم. يُرجى المحاولة مرة أخرى.',
            'timeout_error':
                'استغرق الطلب وقتًا أطول من المتوقع. يُرجى المحاولة مرة أخرى.',
            'camera_unavailable': 'الكاميرا غير متاحة حاليًا.',
            'microphone_unavailable': 'الميكروفون غير متاح حاليًا.',
            'storage_error': 'حدثت مشكلة أثناء حفظ البيانات.',
            'model_error': 'حدثت مشكلة أثناء تشغيل نموذج الذكاء الاصطناعي.',
            'ocr_error': 'تعذّر التعرّف على النص الموجود في الصورة.',
            'speech_error': 'حدثت مشكلة أثناء معالجة الكلام.',
            'unexpected_error': 'حدث خطأ غير متوقع. يُرجى المحاولة مرة أخرى.',
            'ocr_no_text':
                'لم أجد أي نص في الصورة. قرّب الكاميرا من النص وتأكد من الإضاءة.',
            'unauthorized': 'انتهت الجلسة. يُرجى تسجيل الدخول مرة أخرى.',
            'forbidden': 'ليست لديك صلاحية لتنفيذ هذا الإجراء.',
            'not_found': 'لم يتم العثور على المطلوب.',
            'too_many_requests':
                'تم إرسال طلبات كثيرة. انتظر قليلًا ثم حاول مرة أخرى.',
          }
        : const <String, String>{
            'network_error':
                'No internet connection. Check your connection and try again.',
            'server_error':
                'The server encountered a problem. Please try again.',
            'timeout_error': 'The request took too long. Please try again.',
            'camera_unavailable': 'The camera is currently unavailable.',
            'microphone_unavailable':
                'The microphone is currently unavailable.',
            'storage_error': 'Something went wrong while saving data.',
            'model_error': 'The AI model could not complete the operation.',
            'ocr_error': 'Text could not be recognized from the image.',
            'speech_error': 'Something went wrong while processing speech.',
            'unexpected_error':
                'An unexpected error occurred. Please try again.',
            'ocr_no_text':
                'No text found. Move the camera closer to the text and check the lighting.',
            'unauthorized': 'Your session has expired. Please sign in again.',
            'forbidden': 'You do not have permission to do this.',
            'not_found': 'The requested item was not found.',
            'too_many_requests':
                'Too many requests. Wait a moment and try again.',
          };

    return messages[failure.messageKey] ?? messages['unexpected_error']!;
  }

  String _permissionMessage(PermissionFailure failure, bool isArabic) {
    const arLabels = <String, String>{
      'camera': 'الكاميرا',
      'microphone': 'الميكروفون',
      'speech': 'التعرف على الكلام',
      'storage': 'التخزين',
    };
    const enLabels = <String, String>{
      'camera': 'camera',
      'microphone': 'microphone',
      'speech': 'speech recognition',
      'storage': 'storage',
    };

    if (isArabic) {
      final label = arLabels[failure.permission] ?? 'المطلوب';
      return failure.isPermanentlyDenied
          ? 'إذن $label مرفوض. افتح إعدادات الهاتف وفعّل الإذن ثم ارجع للتطبيق.'
          : 'التطبيق يحتاج إذن $label. اضغط على سماح عند ظهور الطلب.';
    }

    final label = enLabels[failure.permission] ?? 'the required';
    return failure.isPermanentlyDenied
        ? 'The $label permission is denied. Open phone settings, enable it, then return to the app.'
        : 'The app needs $label permission. Tap Allow when asked.';
  }
}
