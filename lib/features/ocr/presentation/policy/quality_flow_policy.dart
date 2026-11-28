import '../../../../core/constants/app_defaults.dart';
import '../../../../core/output/output_channel.dart';
import '../../../../core/output/output_priority.dart';

abstract final class QualityFlowPolicy {
  static const String ownerId = 'quality_gate';
  static const String messageKey = 'quality_gate_advice';
  static const String taskKey = 'quality_gate_check';
  static const OutputPriority priority = OutputPriority.high;
  static const OutputHaptic haptic = OutputHaptic.light;
  static const Duration repeatWindow = AppDefaults.errorRepeatWindow;
}
