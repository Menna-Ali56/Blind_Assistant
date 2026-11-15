import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures/failure.dart';
import '../../domain/entities/app_settings.dart';

enum SettingsStatus { loading, ready }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.loading,
    this.settings = const AppSettings(),
    this.failure,
    this.justDeleted = false,
  });

  final SettingsStatus status;
  final AppSettings settings;

  final Failure? failure;

  final bool justDeleted;

  SettingsState copyWith({
    SettingsStatus? status,
    AppSettings? settings,
    Failure? failure,
    bool clearFailure = false,
    bool? justDeleted,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      failure: clearFailure ? null : (failure ?? this.failure),
      justDeleted: justDeleted ?? this.justDeleted,
    );
  }

  @override
  List<Object?> get props => [status, settings, failure, justDeleted];
}
