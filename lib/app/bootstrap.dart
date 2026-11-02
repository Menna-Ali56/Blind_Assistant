import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/cubit/app_bloc_observer.dart';
import '../core/di/injector.dart';
import 'app_modules.dart';
import 'app_providers.dart';

void bootstrap(Widget app) {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  configureDependencies(appModules);
  runApp(AppProviders(child: app));
}
