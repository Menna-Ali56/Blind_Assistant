import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/screen_scaffold.dart';
import '../../../permissions/permissions.dart';
import '../../../camera/domain/entities/captured_image.dart';
import '../cubit/camera_capture_cubit.dart';
import '../widgets/camera_capture_body.dart';

class CameraCapturePage extends StatelessWidget {
  const CameraCapturePage({super.key, required this.onAccepted});

  final ValueChanged<CapturedImage> onAccepted;

  @override
  Widget build(BuildContext context) {
    final texts = context.read<CameraCaptureCubit>().texts;
    return ScreenScaffold(
      title: texts.title,
      child: PermissionGate(
        kind: PermissionKind.camera,
        child: CameraCaptureBody(onAccepted: onAccepted),
      ),
    );
  }
}
