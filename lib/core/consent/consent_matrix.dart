import '../execution/execution_feature.dart';
import 'consent_scope.dart';

ConsentScope? consentScopeOf(ExecutionFeature feature) => switch (feature) {
  ExecutionFeature.currency ||
  ExecutionFeature.signOcr ||
  ExecutionFeature.expiryDate ||
  ExecutionFeature.documentReading ||
  ExecutionFeature.sceneDescription ||
  ExecutionFeature.visualQuestion => ConsentScope.imageUpload,
  ExecutionFeature.conversationalAsr => ConsentScope.audioUpload,
  ExecutionFeature.route => ConsentScope.locationShare,
  ExecutionFeature.obstacleAwareness || ExecutionFeature.voiceCommand => null,
};
