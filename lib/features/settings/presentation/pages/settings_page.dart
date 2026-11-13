import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../settings_strings.dart';
import '../widgets/deleted_view.dart';
import '../widgets/settings_list.dart';
import '../widgets/settings_palette.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = SettingsStrings.of(
      Localizations.localeOf(context).languageCode,
    );
    final palette = SettingsPalette.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state.status == SettingsStatus.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: palette.accent,
                  semanticsLabel: strings.loading,
                ),
              );
            }
            if (state.justDeleted) {
              return DeletedView(
                strings: strings,
                onDone: context.read<SettingsCubit>().acknowledgeDeleted,
              );
            }
            return SettingsList(strings: strings, settings: state.settings);
          },
        ),
      ),
    );
  }
}
