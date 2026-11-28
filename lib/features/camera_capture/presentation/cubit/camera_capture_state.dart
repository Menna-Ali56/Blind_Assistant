import 'package:equatable/equatable.dart';

import '../../../camera/domain/entities/captured_image.dart';
import 'camera_stage.dart';

class CameraCaptureState extends Equatable {
  const CameraCaptureState({this.stage = CameraStage.opening, this.image});

  final CameraStage stage;
  final CapturedImage? image;

  @override
  List<Object?> get props => [stage, image];
}
