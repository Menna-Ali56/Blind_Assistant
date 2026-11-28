import 'package:get_it/get_it.dart';

import '../../core/di/di_module.dart';
import '../permissions/domain/repositories/permission_repository.dart';
import '../permissions/domain/usecases/require_permission.dart';
import 'data/camera_driver.dart';
import 'data/device_camera_service.dart';
import 'data/package_camera_driver.dart';
import 'domain/repositories/camera_service.dart';

class CameraModule implements DiModule {
  const CameraModule();

  @override
  void register(GetIt locator) {
    locator
      ..registerFactory<CameraDriver>(PackageCameraDriver.new)
      ..registerFactory<CameraService>(
        () => DeviceCameraService(
          driver: locator<CameraDriver>(),
          requirePermission: RequirePermission(locator<PermissionRepository>()),
        ),
      );
  }
}
