import 'dart:async';

import '../errors/errors.dart';
import '../tasks/task_cancel_token.dart';
import 'audio_capture.dart';
import 'audio_format.dart';
import 'speech_detector.dart';

enum _EndReason { speechEnded, noSpeech, limit, cancelled, failed }

class UtteranceRecorder {
  UtteranceRecorder(
    this._capture, {
    SpeechDetector Function()? detectorFactory,
    this.maxDuration = defaultMaxDuration,
  }) : _newDetector = detectorFactory ?? SpeechDetector.new;

  static const Duration defaultMaxDuration = Duration(seconds: 15);

  final AudioCapture _capture;
  final SpeechDetector Function() _newDetector;
  final Duration maxDuration;

  Future<Result<AudioClip>> record({TaskCancelToken? cancel}) async {
    final started = await _capture.start();
    Failure? startFailure;
    started.fold(
      onSuccess: (_) {},
      onFailure: (failure) => startFailure = failure,
    );
    final failedToStart = startFailure;
    if (failedToStart != null) return ResultFailure<AudioClip>(failedToStart);

    final detector = _newDetector();
    final end = Completer<(_EndReason, Failure?)>();
    void finish(_EndReason reason, [Failure? failure]) {
      if (!end.isCompleted) end.complete((reason, failure));
    }

    final chunkSub = _capture.chunks.listen((chunk) {
      switch (detector.feed(chunk)) {
        case SpeechSignal.speechEnded:
          finish(_EndReason.speechEnded);
        case SpeechSignal.noSpeech:
          finish(_EndReason.noSpeech);
        case SpeechSignal.speechStarted || SpeechSignal.none:
          break;
      }
    });
    final failureSub = _capture.failures.listen(
      (failure) => finish(_EndReason.failed, failure),
    );
    final limit = Timer(maxDuration, () => finish(_EndReason.limit));
    if (cancel != null) {
      unawaited(cancel.whenCancelled.then((_) => finish(_EndReason.cancelled)));
    }

    final (reason, endFailure) = await end.future;
    limit.cancel();
    await chunkSub.cancel();
    await failureSub.cancel();

    switch (reason) {
      case _EndReason.speechEnded:
        return _capture.stop();
      case _EndReason.limit:
        if (detector.hasSpeech) return _capture.stop();
        return _discard(const SpeechFailure.noInput());
      case _EndReason.noSpeech:
        return _discard(const SpeechFailure.noInput());
      case _EndReason.cancelled:
        return _discard(const CancelledFailure());
      case _EndReason.failed:
        return _discard(endFailure ?? const MicrophoneFailure());
    }
  }

  Future<Result<AudioClip>> _discard(Failure failure) async {
    await _capture.cancel();
    return ResultFailure<AudioClip>(failure);
  }
}
