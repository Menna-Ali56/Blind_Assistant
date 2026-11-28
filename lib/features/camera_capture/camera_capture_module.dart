import 'package:get_it/get_it.dart';

import '../../core/di/cubit_registration.dart';
import '../../core/di/di_module.dart';
import '../../core/errors/errors.dart';
import '../../core/output/output.dart';
import '../camera/domain/repositories/camera_service.dart';
import 'data/camera_service_session.dart';
import 'domain/repositories/camera_session.dart';
import 'presentation/cubit/camera_capture_cubit.dart';

class CameraCaptureModule implements DiModule {
  const CameraCaptureModule({this.languageCode = defaultLanguageCode});

  final String Function() languageCode;

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<CameraSession>()) {
      locator.registerFactory<CameraSession>(
        () => CameraServiceSession(
          locator<CameraService>(),
          onFailure: locator<ErrorSupervisor>().reportFailure,
        ),
      );
    }
    locator.registerCubit<CameraCaptureCubit>(
      (l) => CameraCaptureCubit(
        session: l<CameraSession>(),
        output: l<OutputCoordinator>(),
        languageCode: languageCode,
      ),
    );
  }
}
