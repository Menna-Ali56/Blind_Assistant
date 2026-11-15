import 'dart:ui';

abstract interface class ScreenReaderStatus {
  bool get isActive;
}

class PlatformScreenReaderStatus implements ScreenReaderStatus {
  const PlatformScreenReaderStatus();

  @override
  bool get isActive =>
      PlatformDispatcher.instance.accessibilityFeatures.accessibleNavigation;
}
