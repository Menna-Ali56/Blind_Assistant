import 'output_channel.dart';
import 'output_priority.dart';

class OutputMessage {
  const OutputMessage({
    required this.text,
    required this.languageCode,
    this.priority = OutputPriority.normal,
    this.haptic = OutputHaptic.none,
    this.key,
    this.ownerId,
    this.expiresAfter,
  });

  final String text;
  final String languageCode;
  final OutputPriority priority;
  final OutputHaptic haptic;

  final String? key;

  final String? ownerId;

  final Duration? expiresAfter;
}
