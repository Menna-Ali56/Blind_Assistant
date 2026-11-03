import 'package:flutter/services.dart';

import '../failures/cancelled_failure.dart';
import '../failures/failure.dart';
import '../messages/error_message_mapper.dart';

class ErrorAnnouncer {
  ErrorAnnouncer({
    required this.speak, // مرري هنا دالة الـ TTS بتاعتك
    this.mapper = const ErrorMessageMapper(),
    this.dedupeWindow = const Duration(seconds: 3),
  });

  final Future<void> Function(String text) speak;
  final ErrorMessageMapper mapper;
  final Duration dedupeWindow;

  Failure? _lastFailure;
  DateTime? _lastAt;

  Future<void> announce(Failure failure, {required String languageCode}) async {
    // المستخدم هو اللي لغى، مفيش داعي ننطق.
    if (failure is CancelledFailure) return;

    final now = DateTime.now();
    final lastAt = _lastAt;
    if (failure == _lastFailure &&
        lastAt != null &&
        now.difference(lastAt) < dedupeWindow) {
      return; // نفس الخطأ بالظبط اتنطق من ثواني
    }
    _lastFailure = failure;
    _lastAt = now;

    // الاهتزاز تنبيه إضافي، لو فشل منوقفش النطق.
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}

    // النطق في مسار الأخطاء لازم ما يرميش exception تاني.
    try {
      await speak(mapper.map(failure, languageCode: languageCode));
    } catch (_) {}
  }
}