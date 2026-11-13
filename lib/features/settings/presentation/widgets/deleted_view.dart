import 'package:flutter/material.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../settings_strings.dart';
import 'settings_palette.dart';

/// The "done" screen after the user's data was removed.
class DeletedView extends StatelessWidget {
  const DeletedView({super.key, required this.strings, required this.onDone});

  final SettingsStrings strings;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final palette = SettingsPalette.of(context);
    final text = Theme.of(context).textTheme;
    return ColoredBox(
      color: palette.hero,
      child: Padding(
        padding: const EdgeInsets.all(SettingsPalette.pageGutter),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.deletedTitle,
              style: text.displaySmall?.copyWith(color: palette.onHero),
            ).asHeader().asLiveRegion(),
            const SizedBox(height: 16),
            Text(
              strings.deletedMessage,
              style: text.titleMedium?.copyWith(color: palette.onHero),
            ),
            const SizedBox(height: 32),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: palette.accent,
                foregroundColor: palette.hero,
              ),
              onPressed: onDone,
              child: Text(strings.back),
            ),
          ],
        ),
      ),
    );
  }
}
