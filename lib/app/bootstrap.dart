import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/cubit/app_bloc_observer.dart';
import '../core/di/injector.dart';
import '../core/errors/handlers/global_error_handler.dart';
import 'app_modules.dart';
import 'app_providers.dart';

void bootstrap(Widget app) {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  GlobalErrorHandler().install();
  configureDependencies(appModules);
  runApp(AppProviders(child: app));
}
