import 'package:get_it/get_it.dart';

import '../../core/di/cubit_registration.dart';
import '../../core/di/di_module.dart';
import '../../core/output/output.dart';
import 'data/repositories/in_memory_permission_flow_progress.dart';
import 'data/repositories/permission_handler_repository.dart';
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
        InMemoryPermissionFlowProgress.new,
      )
      ..registerLazySingleton<GrantedPermissions>(GrantedPermissions.new)
      ..registerSharedCubit<PermissionsCubit>(
        (_) => PermissionsCubit(
          repository: locator<PermissionRepository>(),
          granted: locator<GrantedPermissions>(),
          progress: locator<PermissionFlowProgress>(),
          output: locator<OutputCoordinator>(),
          languageCode: languageCode,
        ),
      );
  }
}
