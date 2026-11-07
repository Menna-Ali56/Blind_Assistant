import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/cubit/app_bloc_observer.dart';
import '../core/di/injector.dart';
import '../core/errors/errors.dart';
import 'app_modules.dart';
import 'app_providers.dart';

void bootstrap(Widget app) {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  GlobalErrorHandler(onUnhandled: _reportUncaught).install();
  configureDependencies(appModules);
  runApp(AppProviders(child: app));
}

void _reportUncaught(Object error, StackTrace stack) {
  sl<ErrorSupervisor>().report(
    error,
    stackTrace: stack,
    source: 'uncaught',
    uncaught: true,
    log: false, // GlobalErrorHandler already logged it
  );
}