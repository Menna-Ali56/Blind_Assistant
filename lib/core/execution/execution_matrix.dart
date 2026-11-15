import '../errors/exceptions/permission_exception.dart';
import 'execution_feature.dart';
import 'execution_lane.dart';
import 'execution_policy.dart';

const _camera = {AppPermission.camera};
const _microphone = {AppPermission.microphone};
const _location = {AppPermission.location};

const _localFirstCamera = ExecutionPolicy(
  placement: ExecutionPlacement.localFirst,
  permissions: _camera,
);
const _cloudFirstCamera = ExecutionPolicy(
  placement: ExecutionPlacement.cloudFirst,
  permissions: _camera,
);
const _cloudOnlyCamera = ExecutionPolicy(
  placement: ExecutionPlacement.cloudOnly,
  permissions: _camera,
);
const _localOnlyCamera = ExecutionPolicy(
  placement: ExecutionPlacement.localOnly,
  permissions: _camera,
);
const _localOnlyMicrophone = ExecutionPolicy(
  placement: ExecutionPlacement.localOnly,
  permissions: _microphone,
);
const _cloudOnlyMicrophone = ExecutionPolicy(
  placement: ExecutionPlacement.cloudOnly,
  permissions: _microphone,
);
const _cloudOnlyLocation = ExecutionPolicy(
  placement: ExecutionPlacement.cloudOnly,
  permissions: _location,
);

typedef PolicyLookup = ExecutionPolicy Function(ExecutionFeature feature);

ExecutionPolicy executionPolicyOf(ExecutionFeature feature) =>
    switch (feature) {
      ExecutionFeature.currency ||
      ExecutionFeature.signOcr ||
      ExecutionFeature.expiryDate => _localFirstCamera,
      ExecutionFeature.documentReading => _cloudFirstCamera,
      ExecutionFeature.sceneDescription ||
      ExecutionFeature.visualQuestion => _cloudOnlyCamera,
      ExecutionFeature.obstacleAwareness => _localOnlyCamera,
      ExecutionFeature.voiceCommand => _localOnlyMicrophone,
      ExecutionFeature.conversationalAsr => _cloudOnlyMicrophone,
      ExecutionFeature.route => _cloudOnlyLocation,
    };
