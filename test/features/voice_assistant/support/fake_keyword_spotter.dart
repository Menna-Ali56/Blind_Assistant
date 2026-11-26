import 'dart:async';

import 'package:baseer/features/voice_assistant/spotter.dart';

class FakeKeywordSpotter implements KeywordSpotter {
  FakeKeywordSpotter({this.failOnStart = false});

  final bool failOnStart;
  final StreamController<SpotterEvent> _controller =
      StreamController<SpotterEvent>.broadcast(sync: true);

  int startCalls = 0;
  int stopCalls = 0;

  bool get hasListener => _controller.hasListener;

  @override
  Stream<SpotterEvent> get events => _controller.stream;

  @override
  Future<void> start() async {
    startCalls++;
    if (failOnStart) throw StateError('start failed');
  }

  @override
  Future<void> stop() async => stopCalls++;

  void emit(String keyword, double confidence) {
    _controller.add(SpotterEvent(keyword: keyword, confidence: confidence));
  }
}
