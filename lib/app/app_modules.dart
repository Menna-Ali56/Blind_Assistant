import '../core/di/di_module.dart';
import '../core/errors/errors_module.dart';
import '../core/execution/execution_module.dart';
import '../core/network/network_module.dart';
import '../core/output/output_module.dart';
import '../core/storage/storage_module.dart';
import '../core/tasks/tasks_module.dart';
import '../features/permissions/permissions_module.dart';
import '../features/settings/settings_module.dart';
import '../features/theme/theme_module.dart';
import 'navigation_module.dart';

const List<DiModule> appModules = [
  ErrorsModule(),
  OutputModule(),
  NetworkModule(),
  ThemeModule(),
  PermissionsModule(),
  NavigationModule(),
  ExecutionModule(),
  TasksModule(),
  StorageModule(),
  SettingsModule(),
];
