abstract final class AppDefaults {
  static const double textScale = 1.0;
  static const double minTextScale = 1.0;
  static const double maxTextScale = 2.0;
  static const Duration errorRepeatWindow = Duration(seconds: 3);
  static const double localConfidenceThreshold = 0.60;
  static const int maxImageBytes = 5 * 1024 * 1024;
  static const List<int> imageQualitySteps = [90, 75, 60, 45];
  static const int maxSameRequestRetries = 2;
  static const Duration localInferenceTimeout = Duration(milliseconds: 1500);
}
