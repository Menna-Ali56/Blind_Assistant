import 'cue_output.dart';
import 'feedback_cue.dart';

class FeedbackCoordinator implements CueOutput {
  FeedbackCoordinator(List<CueOutput> outputs, {this.onError})
    : _outputs = List.unmodifiable(outputs);

  final List<CueOutput> _outputs;
  final void Function(Object error, StackTrace stackTrace)? onError;

  @override
  Future<void> play(FeedbackCue cue) => _fanOut((output) => output.play(cue));

  @override
  Future<void> cancel() => _fanOut((output) => output.cancel());

  Future<void> _fanOut(Future<void> Function(CueOutput output) action) async {
    await Future.wait(_outputs.map((output) => _guard(() => action(output))));
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stackTrace) {
      try {
        onError?.call(error, stackTrace);
      } catch (_) {}
    }
  }
}
