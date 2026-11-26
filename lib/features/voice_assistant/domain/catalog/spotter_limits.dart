import '../../../../core/constants/app_defaults.dart';
import '../../data/catalog/command_keywords.dart';

abstract final class SpotterLimits {
  static const Duration wakeWindow = Duration(seconds: 8);
  static const double wakeConfidence = 0.80;
  static const double commandConfidence = AppDefaults.localConfidenceThreshold;

  static final Map<String, double> thresholds = {
    CommandKeywords.wakeId: wakeConfidence,
    for (final id in CommandKeywords.commandIds) id: commandConfidence,
  };
}
