import 'package:get_it/get_it.dart';

import '../../core/accessibility/screen_reader_status.dart';
import '../../core/di/cubit_registration.dart';
import '../../core/di/di_module.dart';
import '../../core/output/output.dart';
import '../../core/storage/secure_store.dart';
import 'data/repositories/permission_handler_repository.dart';
import 'data/repositories/secure_permission_flow_progress.dart';
import 'domain/entities/granted_permissions.dart';
import 'domain/repositories/permission_flow_progress.dart';
import 'domain/repositories/permission_repository.dart';
import 'presentation/cubit/permissions_cubit.dart';

class PermissionsModule implements DiModule {
  const PermissionsModule({this.languageCode = defaultLanguageCode});

  final String Function() languageCode;

  @override
  void register(GetIt locator) {
    locator
      ..registerLazySingleton<PermissionRepository>(
        () => const PermissionHandlerRepository(),
      )
      ..registerLazySingleton<PermissionFlowProgress>(
        () => SecurePermissionFlowProgress(locator<SecureStore>()),
      )
      ..registerLazySingleton<GrantedPermissions>(GrantedPermissions.new)
      ..registerSharedCubit<PermissionsCubit>(
        (_) => PermissionsCubit(
          repository: locator<PermissionRepository>(),
          granted: locator<GrantedPermissions>(),
          progress: locator<PermissionFlowProgress>(),
          output: locator<OutputCoordinator>(),
          languageCode: languageCode,
          screenReader: locator.isRegistered<ScreenReaderStatus>()
              ? locator<ScreenReaderStatus>()
              : const PlatformScreenReaderStatus(),
        ),
      );
  }
}
