import 'package:baseer/core/errors/exceptions/permission_exception.dart';
import 'package:baseer/core/errors/failures/failures.dart';
import 'package:baseer/core/errors/messages/error_message_mapper.dart';
import 'package:baseer/core/execution/unavailable_reason.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = ErrorMessageMapper();

  group('ErrorMessageMapper execution failures', () {
    test('maps execution offline message in english and arabic', () {
      final failure = ExecutionFailure(UnavailableReason.offline);
      expect(
        mapper.map(failure, languageCode: 'en'),
        'This feature needs an internet connection.',
      );
      expect(
        mapper.map(failure, languageCode: 'ar'),
        'هذه الميزة تحتاج إلى اتصال بالإنترنت.',
      );
    });

    test('maps consent missing message in english and arabic', () {
      final failure = ExecutionFailure(UnavailableReason.consentMissing);
      expect(
        mapper.map(failure, languageCode: 'en'),
        'I need your permission to send this to the server.',
      );
      expect(
        mapper.map(failure, languageCode: 'ar'),
        'أحتاج موافقتك لإرسال هذا الطلب إلى الخادم.',
      );
    });

    test('maps no local model message in english and arabic', () {
      final failure = ExecutionFailure(UnavailableReason.noLocalModel);
      expect(
        mapper.map(failure, languageCode: 'en'),
        'This feature is not available offline right now.',
      );
      expect(
        mapper.map(failure, languageCode: 'ar'),
        'هذه الميزة غير متاحة بدون إنترنت حاليًا.',
      );
    });

    test('maps low confidence message in english and arabic', () {
      final failure = ExecutionFailure(UnavailableReason.lowConfidence);
      expect(
        mapper.map(failure, languageCode: 'en'),
        'The result is not clear. Hold steady and try again.',
      );
      expect(
        mapper.map(failure, languageCode: 'ar'),
        'النتيجة غير واضحة. ثبّت الكاميرا وحاول مرة أخرى.',
      );
    });
  });

  group('ErrorMessageMapper location permission', () {
    test('maps location permission in english', () {
      const normal = PermissionFailure(permission: AppPermission.location);
      const denied = PermissionFailure(
        permission: AppPermission.location,
        isPermanentlyDenied: true,
      );
      expect(
        mapper.map(normal, languageCode: 'en'),
        'The app needs location permission. Tap Allow when asked.',
      );
      expect(
        mapper.map(denied, languageCode: 'en'),
        'The location permission is denied. Open phone settings, enable it, then return to the app.',
      );
    });

    test('maps location permission in arabic', () {
      const normal = PermissionFailure(permission: AppPermission.location);
      const denied = PermissionFailure(
        permission: AppPermission.location,
        isPermanentlyDenied: true,
      );
      expect(
        mapper.map(normal, languageCode: 'ar'),
        'التطبيق يحتاج إذن الموقع. اضغط على سماح عند ظهور الطلب.',
      );
      expect(
        mapper.map(denied, languageCode: 'ar'),
        'إذن الموقع مرفوض. افتح إعدادات الهاتف وفعّل الإذن ثم ارجع للتطبيق.',
      );
    });
  });
}
