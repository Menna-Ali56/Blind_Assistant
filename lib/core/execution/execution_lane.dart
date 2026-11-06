enum ExecutionLane { local, cloud }

enum ExecutionPlacement {
  localOnly([ExecutionLane.local]),
  localFirst([ExecutionLane.local, ExecutionLane.cloud]),
  cloudFirst([ExecutionLane.cloud, ExecutionLane.local]),
  cloudOnly([ExecutionLane.cloud]);

  const ExecutionPlacement(this.lanes);

  final List<ExecutionLane> lanes;

  bool get hasCloudFallback => this == localFirst;
}
