import 'feedback_cue.dart';
import 'haptic_spec.dart';

const Map<FeedbackCue, HapticSpec> hapticCatalog = {
  FeedbackCue.listening: HapticSpec([HapticPulse(40)], strength: 0.6),
  FeedbackCue.done: HapticSpec([
    HapticPulse(30, 60),
    HapticPulse(30),
  ], strength: 0.6),
  FeedbackCue.error: HapticSpec([
    HapticPulse(200, 80),
    HapticPulse(200),
  ], strength: 0.9),
  FeedbackCue.warningInfo: HapticSpec([HapticPulse(80)], strength: 0.7),
  FeedbackCue.warningUrgent: HapticSpec([
    HapticPulse(100, 60),
    HapticPulse(100, 60),
    HapticPulse(100),
  ], strength: 0.9),
  FeedbackCue.warningEmergency: HapticSpec([
    HapticPulse(400, 100),
    HapticPulse(400, 100),
    HapticPulse(400),
  ]),
};
