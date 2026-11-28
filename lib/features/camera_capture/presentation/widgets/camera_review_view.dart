import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../camera/domain/entities/captured_image.dart';
import '../cubit/camera_capture_cubit.dart';
import '../cubit/camera_stage.dart';
import 'camera_action_button.dart';
import 'camera_screen_layout.dart';

class CameraReviewView extends StatelessWidget {
  const CameraReviewView({super.key, required this.image});

  final CapturedImage image;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CameraCaptureCubit>();
    final texts = cubit.texts;
    return CameraScreenLayout(
      content: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Image.memory(
          image.bytes,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ).asImage(texts.reviewLabel),
      message: texts.spoken(CameraStage.review),
      actions: [
        CameraActionButton(label: texts.useAction, onTap: cubit.use),
        CameraActionButton(
          label: texts.retakeAction,
          onTap: cubit.retake,
          primary: false,
        ),
      ],
    );
  }
}
