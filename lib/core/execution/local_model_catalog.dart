import 'execution_feature.dart';

abstract interface class LocalModelCatalog {
  bool isReady(ExecutionFeature feature);
}

class NoLocalModels implements LocalModelCatalog {
  const NoLocalModels();

  @override
  bool isReady(ExecutionFeature feature) => false;
}
