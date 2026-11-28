import 'package:go_router/go_router.dart';

import '../../core/di/injected_cubit.dart';
import '../camera/domain/entities/captured_image.dart';
import 'presentation/cubit/camera_capture_cubit.dart';
import 'presentation/pages/camera_capture_page.dart';

const String cameraCapturePath = '/camera';

GoRoute cameraCaptureRoute() => GoRoute(
  path: cameraCapturePath,
  builder: (context, state) => InjectedCubit<CameraCaptureCubit>(
    child: CameraCapturePage(
      onAccepted: (CapturedImage image) => context.pop(image),
    ),
  ),
);
