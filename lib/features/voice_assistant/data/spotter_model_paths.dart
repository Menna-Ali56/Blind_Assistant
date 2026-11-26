import 'spotter_model_config.dart';

class SpotterModelPaths {
  const SpotterModelPaths(this._paths);

  final Map<SpotterFileRole, String> _paths;

  String operator [](SpotterFileRole role) => _paths[role]!;
}
