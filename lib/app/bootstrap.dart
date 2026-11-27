import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/cubit/app_bloc_observer.dart';
import '../core/di/injector.dart';
import '../core/errors/errors.dart';
import '../core/network/connectivity_monitor.dart';
import '../core/output/output.dart';
import '../core/safety/safety.dart';
import '../features/consent/consent.dart';
import '../features/permissions/domain/repositories/permission_flow_progress.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import 'app_modules.dart';
import 'app_providers.dart';

const String _uncaughtSource = 'uncaught';
const String _connectivitySource = 'connectivity_monitor';

Future<void> bootstrap(Widget app) async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  GlobalErrorHandler(onUnhandled: _reportUncaught).install();

  ErrorWidget.builder = (_) => const SafeErrorView();

  configureDependencies(appModules);

  await _startConnectivityMonitor();

  await sl<PermissionFlowProgress>().load();
  await sl<ConsentCubit>().load();
  await sl<SettingsCubit>().load();

  sl<ErrorOutputBridge>().start();
  sl<SafeStateGuard>().start();

  runApp(AppProviders(child: app));

  // Temporary TTS device integration test.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    sl<OutputCoordinator>().submit(
      OutputMessage(
        text: 'مرحبًا بك في بصير، أنا مساعدك الصوتي.',
        languageCode: 'ar',
        key: 'tts_device_test',
        ownerId: 'tts_device_test',
      ),
    );
  });
}

Future<void> _startConnectivityMonitor() async {
  try {
    await sl<ConnectivityMonitor>().start();
  } catch (error, stackTrace) {
    sl<ErrorSupervisor>().report(
      error,
      stackTrace: stackTrace,
      source: _connectivitySource,
    );
  }
}

void _reportUncaught(Object error, StackTrace stack) {
  sl<ErrorSupervisor>().report(
    error,
    stackTrace: stack,
    source: _uncaughtSource,
    uncaught: true,
    log: false,
  );
}
