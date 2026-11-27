import '../../../../core/output/output.dart';
import '../../domain/interaction/spoken_reply.dart';

/// Speaks through the app's [OutputCoordinator], so the reply is queued with
/// everything else, ducks other audio, and respects the screen reader.
class OutputSpokenReply implements SpokenReply {
  OutputSpokenReply(this._output);

  static const String ownerId = 'voice_interaction';
  static const String replyKey = 'voice_interaction_reply';

  final OutputCoordinator _output;

  @override
  Future<void> say(String text, {required String languageCode}) {
    _output.submit(
      OutputMessage(
        text: text,
        languageCode: languageCode,
        key: replyKey,
        ownerId: ownerId,
      ),
    );
    return whenIdle();
  }

  @override
  Future<void> whenIdle() async {
    // Error announcements reach the output queue a moment after they are
    // reported (the report stream delivers asynchronously). Let them in.
    await Future<void>.delayed(Duration.zero);
    if (!_output.isBusy) return;
    await _output.busyChanges.firstWhere((busy) => !busy, orElse: () => false);
  }

  @override
  Future<void> stop() async => _output.cancelOwner(ownerId);
}
