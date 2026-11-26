import 'earcon_spec.dart';
import 'feedback_cue.dart';

abstract final class EarconCatalog {
  static const int sampleRate = 22050;
  static const Duration fade = Duration(milliseconds: 8);
  static const Duration completionGrace = Duration(milliseconds: 400);

  static const Duration _gap = Duration(milliseconds: 50);
  static const Duration _short = Duration(milliseconds: 90);
  static const Duration _long = Duration(milliseconds: 280);

  static const EarconSpec _listening = EarconSpec(
    frequencyHz: 880,
    tone: _short,
    gap: _gap,
    volume: 0.5,
    repeat: 1,
  );
  static const EarconSpec _done = EarconSpec(
    frequencyHz: 1320,
    tone: _short,
    gap: _gap,
    volume: 0.5,
    repeat: 2,
  );
  static const EarconSpec _error = EarconSpec(
    frequencyHz: 220,
    tone: _long,
    gap: _gap,
    volume: 0.7,
    repeat: 1,
  );
  static const EarconSpec _warningInfo = EarconSpec(
    frequencyHz: 660,
    tone: _short,
    gap: _gap,
    volume: 0.6,
    repeat: 1,
  );
  static const EarconSpec _warningUrgent = EarconSpec(
    frequencyHz: 990,
    tone: _short,
    gap: _gap,
    volume: 0.8,
    repeat: 2,
  );
  static const EarconSpec _warningEmergency = EarconSpec(
    frequencyHz: 1760,
    tone: _short,
    gap: _gap,
    volume: 1.0,
    repeat: 3,
  );

  static EarconSpec of(FeedbackCue cue) => switch (cue) {
    FeedbackCue.listening => _listening,
    FeedbackCue.done => _done,
    FeedbackCue.error => _error,
    FeedbackCue.warningInfo => _warningInfo,
    FeedbackCue.warningUrgent => _warningUrgent,
    FeedbackCue.warningEmergency => _warningEmergency,
  };
}
