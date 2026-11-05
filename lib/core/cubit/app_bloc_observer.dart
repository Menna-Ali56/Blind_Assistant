import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../errors/handlers/error_logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _log(bloc, change);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _log(bloc, error);
    const ErrorLogger().log(error, stackTrace, context: bloc.runtimeType.toString());
    super.onError(bloc, error, stackTrace);
  }

  void _log(BlocBase<dynamic> bloc, Object detail) {
    if (kDebugMode) {
      debugPrint('${bloc.runtimeType} $detail');
    }
  }
}
