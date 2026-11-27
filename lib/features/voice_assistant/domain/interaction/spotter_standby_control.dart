import '../controller/spotter_controller.dart';
import 'standby_control.dart';

class SpotterStandbyControl implements StandbyControl {
  const SpotterStandbyControl(this._spotter);

  final SpotterController _spotter;

  @override
  Future<void> start() => _spotter.start();

  @override
  Future<void> stop() => _spotter.stop();
}
