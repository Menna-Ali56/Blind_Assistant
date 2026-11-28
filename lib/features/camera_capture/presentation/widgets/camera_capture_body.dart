import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../camera/domain/entities/captured_image.dart';
import '../cubit/camera_capture_cubit.dart';
import '../cubit/camera_capture_state.dart';
import '../cubit/camera_stage.dart';
import 'camera_action_button.dart';
import 'camera_live_view.dart';
import 'camera_message_view.dart';
import 'camera_review_view.dart';

class CameraCaptureBody extends StatefulWidget {
  const CameraCaptureBody({super.key, required this.onAccepted});

  final ValueChanged<CapturedImage> onAccepted;

  @override
  State<CameraCaptureBody> createState() => _CameraCaptureBodyState();
}

class _CameraCaptureBodyState extends State<CameraCaptureBody> {
  @override
  void initState() {
    super.initState();
    context.read<CameraCaptureCubit>().open();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraCaptureCubit, CameraCaptureState>(
      listenWhen: (previous, current) =>
          current.stage == CameraStage.accepted && current.image != null,
      listener: (context, state) => widget.onAccepted(state.image!),
      builder: _view,
    );
  }

  Widget _view(BuildContext context, CameraCaptureState state) {
    final cubit = context.read<CameraCaptureCubit>();
    final texts = cubit.texts;
    final message = texts.spoken(state.stage);
    final image = state.image;
    if (state.stage == CameraStage.ready) return const CameraLiveView();
    if (state.stage == CameraStage.review && image != null) {
      return CameraReviewView(image: image);
    }
    if (state.stage.isFailure) {
      return CameraMessageView(
        message: message,
        trailing: CameraActionButton(
          label: texts.retryAction,
          onTap: cubit.retry,
        ),
      );
    }
    return CameraMessageView(
      message: message,
      leading: const CircularProgressIndicator().decorative(),
    );
  }
}
