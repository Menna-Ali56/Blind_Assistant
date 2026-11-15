import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../settings_strings.dart';
import 'settings_palette.dart';

/// Asks before everything is removed. Cancel has the focus, so a stray
/// double tap does not delete anything.
class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key, required this.strings});

  final SettingsStrings strings;

  @override
  Widget build(BuildContext context) {
    final palette = SettingsPalette.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: palette.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SettingsPalette.cardRadius),
      ),
      title: Text(
        strings.deleteTitle,
        style: text.titleLarge?.copyWith(
          color: palette.title,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        strings.deleteMessage,
        style: text.bodyLarge?.copyWith(color: palette.subtitle),
      ),
      actionsOverflowDirection: VerticalDirection.down,
      actions: [
        OutlinedButton(
          autofocus: true,
          style: OutlinedButton.styleFrom(
            foregroundColor: palette.accentDark,
            side: BorderSide(color: palette.accent, width: 2),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(strings.deleteCancel),
        ),
        const SizedBox(height: AppDimens.itemGap),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(strings.deleteConfirm),
        ),
      ],
    );
  }
}
