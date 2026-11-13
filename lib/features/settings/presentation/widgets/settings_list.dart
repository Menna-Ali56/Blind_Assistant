import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_settings.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/text_size_step.dart';
import '../settings_strings.dart';
import 'delete_dialog.dart';
import 'setting_row.dart';
import 'settings_palette.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({
    super.key,
    required this.strings,
    required this.settings,
  });

  final SettingsStrings strings;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final palette = SettingsPalette.of(context);
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(
        SettingsPalette.pageGutter,
        16,
        SettingsPalette.pageGutter,
        32,
      ),
      children: [
        if (Navigator.of(context).canPop())
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              tooltip: strings.goBack,
              icon: Icon(Icons.arrow_back, color: palette.title),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        Text(
          strings.eyebrow,
          style: text.labelLarge?.copyWith(
            color: palette.accentDark,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 4),
        Semantics(
          header: true,
          child: Text(
            strings.title,
            style: text.displaySmall?.copyWith(
              color: palette.title,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _section(palette, text, strings.sectionAccessibility, [
          _row(
            Icons.text_fields,
            strings.textSize,
            strings.textSizeValue(TextSizeStep.fromScale(settings.textScale)),
            cubit.cycleTextSize,
          ),
          _row(
            Icons.contrast,
            strings.highContrast,
            strings.onOff(settings.highContrast),
            cubit.toggleHighContrast,
            toggle: settings.highContrast,
          ),
          _row(
            Icons.volume_up_outlined,
            strings.voiceRate,
            strings.voiceRateValue(settings.voiceRate),
            cubit.cycleVoiceRate,
          ),
        ]),
        _section(palette, text, strings.sectionPreferences, [
          _row(
            Icons.vibration,
            strings.haptics,
            strings.onOff(settings.haptics),
            cubit.toggleHaptics,
            toggle: settings.haptics,
          ),
          _row(
            Icons.mic_none,
            strings.wakeWord,
            strings.onOff(settings.wakeWord),
            cubit.toggleWakeWord,
            toggle: settings.wakeWord,
          ),
          _row(
            Icons.photo_camera_outlined,
            strings.imageUpload,
            strings.allowed(settings.allowImageUpload),
            cubit.toggleImageUpload,
            toggle: settings.allowImageUpload,
          ),
        ]),
        _section(palette, text, strings.sectionPrivacy, [
          _row(
            Icons.delete_outline,
            strings.deleteData,
            strings.deleteValue,
            () => _confirmDelete(context, cubit),
            hint: strings.deleteHint,
            destructive: true,
          ),
        ]),
      ],
    );
  }

  /// A small uppercase label followed by one white rounded card of rows.
  Widget _section(
    SettingsPalette palette,
    TextTheme text,
    String label,
    List<Widget> rows,
  ) {
    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      if (i > 0) {
        children.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: palette.divider,
          ),
        );
      }
      children.add(rows[i]);
    }
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, bottom: 10),
            child: Semantics(
              header: true,
              child: Text(
                label,
                style: text.labelLarge?.copyWith(
                  color: palette.sectionLabel,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(SettingsPalette.cardRadius),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _row(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap, {
    String? hint,
    bool? toggle,
    bool destructive = false,
  }) {
    return SettingRow(
      icon: icon,
      label: label,
      value: value,
      semanticLabel: strings.rowLabel(label, value),
      hint: hint ?? strings.changeHint,
      onTap: onTap,
      kind: toggle == null ? SettingRowKind.navigate : SettingRowKind.toggle,
      isOn: toggle ?? false,
      destructive: destructive,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SettingsCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteDialog(strings: strings),
    );
    if (confirmed ?? false) await cubit.deleteAllData();
  }
}
