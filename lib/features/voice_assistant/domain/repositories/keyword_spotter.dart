import '../entities/spotter_event.dart';

abstract interface class KeywordSpotter {
  Stream<SpotterEvent> get events;
  Future<void> start();
  Future<void> stop();
}
