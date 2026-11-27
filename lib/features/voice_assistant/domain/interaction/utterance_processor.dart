import '../../../../core/audio/audio_format.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/tasks/task_cancel_token.dart';
import '../entities/command_outcome.dart';

/// Turns what the user said into an answer: speech recognition, finding the
/// command, running it. The assistant only needs the words to speak back.
///
/// Stop early when [cancel] fires.
abstract interface class UtteranceProcessor {
  Future<Result<CommandOutcome>> process(
    AudioClip clip, {
    required TaskCancelToken cancel,
  });
}

/// Used until a real processor is registered. Every turn ends with a spoken
/// speech error, so a missing backend is noticed instead of silent.
class UnavailableUtteranceProcessor implements UtteranceProcessor {
  const UnavailableUtteranceProcessor();

  @override
  Future<Result<CommandOutcome>> process(
    AudioClip clip, {
    required TaskCancelToken cancel,
  }) async => const ResultFailure<CommandOutcome>(SpeechFailure());
}
