import '../cubit/camera_stage.dart';

class CameraTexts {
  const CameraTexts({
    required this.title,
    required this.previewLabel,
    required this.reviewLabel,
    required this.captureAction,
    required this.retakeAction,
    required this.useAction,
    required this.retryAction,
    required this.messages,
  });

  final String title;
  final String previewLabel;
  final String reviewLabel;
  final String captureAction;
  final String retakeAction;
  final String useAction;
  final String retryAction;
  final Map<CameraStage, String> messages;

  String spoken(CameraStage stage) => messages[stage]!;
}
