import 'dart:typed_data';

import 'package:baseer/core/feedback/cue_output.dart';
import 'package:baseer/core/feedback/earcon_driver.dart';
import 'package:baseer/core/feedback/feedback_cue.dart';

class FakeEarconDriver implements EarconDriver {
  FakeEarconDriver({this.fails = false});

  final bool fails;
  final List<Uint8List> played = [];
  final List<Duration> lengths = [];
  int stops = 0;

  @override
  Future<void> play(Uint8List wav, {required Duration length}) async {
    if (fails) throw StateError('driver broke');
    played.add(wav);
    lengths.add(length);
  }

  @override
  Future<void> stop() async => stops++;

  @override
  Future<void> dispose() async {}
}

class RecordingCueOutput implements CueOutput {
  RecordingCueOutput({this.fails = false});

  final bool fails;
  final List<FeedbackCue> cues = [];
  int cancels = 0;

  @override
  Future<void> play(FeedbackCue cue) async {
    cues.add(cue);
    if (fails) throw StateError('cue broke');
  }

  @override
  Future<void> cancel() async => cancels++;
}
