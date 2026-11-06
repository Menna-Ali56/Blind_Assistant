import '../failures/failure.dart';
import '../failures/permission_failure.dart';
import 'error_messages_ar.dart';
import 'error_messages_en.dart';

class ErrorMessageMapper {
  const ErrorMessageMapper();

  String map(Failure failure, {required String languageCode}) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    if (failure is PermissionFailure) {
      return _permissionMessage(failure, isArabic);
    }

    final messages = isArabic ? arabicErrorMessages : englishErrorMessages;
    return messages[failure.messageKey] ?? messages['unexpected_error']!;
  }

  String _permissionMessage(PermissionFailure failure, bool isArabic) {
    if (isArabic) {
      final label = arabicPermissionLabels[failure.permission] ?? 'المطلوب';
      return failure.isPermanentlyDenied
          ? 'إذن $label مرفوض. افتح إعدادات الهاتف وفعّل الإذن ثم ارجع للتطبيق.'
          : 'التطبيق يحتاج إذن $label. اضغط على سماح عند ظهور الطلب.';
    }

    final label = englishPermissionLabels[failure.permission] ?? 'the required';
    return failure.isPermanentlyDenied
        ? 'The $label permission is denied. Open phone settings, enable it, then return to the app.'
        : 'The app needs $label permission. Tap Allow when asked.';
  }
}
