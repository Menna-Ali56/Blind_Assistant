import 'dart:ui' show PlatformDispatcher, TextDirection;

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../constants/app_languages.dart';
import 'output_channel.dart';
import 'output_priority.dart';

class AnnouncementChannel implements OutputChannel {
  const AnnouncementChannel();

  static const Duration perCharacter = Duration(milliseconds: 60);

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  }) async {
    final view = PlatformDispatcher.instance.implicitView;
    if (view == null) return;
    await SemanticsService.sendAnnouncement(
      view,
      text,
      _directionOf(languageCode),
    );
    await Future<void>.delayed(perCharacter * text.length);
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> haptic(OutputHaptic kind) => switch (kind) {
    OutputHaptic.none => Future<void>.value(),
    OutputHaptic.light => HapticFeedback.lightImpact(),
    OutputHaptic.heavy => HapticFeedback.heavyImpact(),
  };

  TextDirection _directionOf(String languageCode) =>
      languageCode.toLowerCase().startsWith(AppLanguages.arabic)
      ? TextDirection.rtl
      : TextDirection.ltr;
}
