import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../cubit/camera_capture_cubit.dart';
import '../cubit/camera_stage.dart';
import 'camera_action_button.dart';
import 'camera_screen_layout.dart';

class CameraLiveView extends StatelessWidget {
  const CameraLiveView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CameraCaptureCubit>();
    final texts = cubit.texts;
    return CameraScreenLayout(
      content: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: cubit.session.buildPreview(context),
      ).asImage(texts.previewLabel),
      message: texts.spoken(CameraStage.ready),
      actions: [
        CameraActionButton(label: texts.captureAction, onTap: cubit.capture),
      ],
    );
  }
}
