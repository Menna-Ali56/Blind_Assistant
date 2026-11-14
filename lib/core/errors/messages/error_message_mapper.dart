import '../failures/failure.dart';
import '../failures/permission_failure.dart';
import '../failures/retry_hint.dart';
import '../mappers/error_code_registry.dart';
import 'error_messages_ar.dart';
import 'error_messages_en.dart';

class ErrorMessageMapper {
  const ErrorMessageMapper();

  static const Map<RetryHint, String> _actionKeys = {
    RetryHint.sameRequest: 'action_retry',
    RetryHint.newCapture: 'action_new_capture',
    RetryHint.login: 'action_sign_in',
  };

  String map(Failure failure, {required String languageCode}) {
    if (failure is PermissionFailure) {
      return _permissionMessage(failure, _isArabic(languageCode));
    }

    final messages = _messagesFor(languageCode);
    return messages[failure.messageKey] ??
        messages[ErrorCodeRegistry.unknownMessageKey]!;
  }

  String? actionLabel(RetryHint hint, {required String languageCode}) {
    final key = _actionKeys[hint];
    return key == null ? null : _messagesFor(languageCode)[key];
  }

  bool _isArabic(String languageCode) =>
      languageCode.toLowerCase().startsWith('ar');

  Map<String, String> _messagesFor(String languageCode) =>
      _isArabic(languageCode) ? arabicErrorMessages : englishErrorMessages;

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
