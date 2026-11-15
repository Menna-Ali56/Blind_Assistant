import 'dart:async';

import '../../../../core/errors/handlers/error_logger.dart';
import '../../../../core/errors/handlers/remote_sync_guard.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/preferences_remote.dart';
import 'settings_effect.dart';

class PreferencesSyncEffect implements SettingsEffect {
  PreferencesSyncEffect(this._remote, {this._logger = const ErrorLogger()});

  static const String _syncContext = 'preferences_sync';

  final PreferencesRemote _remote;
  final ErrorLogger _logger;
  AppSettings? _last;

  @override
  void apply(AppSettings settings) {
    if (_last == settings) return;
    _last = settings;
    unawaited(
      runRemoteSync(
        () => _remote.save(settings),
        context: _syncContext,
        logger: _logger,
      ),
    );
  }
}
