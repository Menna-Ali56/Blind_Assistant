import 'package:flutter/material.dart';

import 'settings_palette.dart';

enum SettingRowKind { navigate, toggle }

/// One row inside a settings card: icon tile, name with its current value
/// underneath, and either a toggle or a chevron on the far side.
/// It lights up when the screen reader (or the keyboard) is on it.
class SettingRow extends StatefulWidget {
  const SettingRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.semanticLabel,
    required this.hint,
    required this.onTap,
    this.kind = SettingRowKind.navigate,
    this.isOn = false,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final String value;

  /// What the screen reader says, for example "Voice speed, Normal".
  final String semanticLabel;
  final String hint;
  final VoidCallback onTap;
  final SettingRowKind kind;

  /// Only used when [kind] is [SettingRowKind.toggle].
  final bool isOn;

  /// Paints the icon and name red (delete data).
  final bool destructive;

  @override
  State<SettingRow> createState() => _SettingRowState();
}

class _SettingRowState extends State<SettingRow> {
  bool _highlighted = false;

  void _highlight(bool value) {
    if (_highlighted == value) return;
    setState(() => _highlighted = value);
  }

  @override
  Widget build(BuildContext context) {
    final palette = SettingsPalette.of(context);
    final text = Theme.of(context).textTheme;
    final isToggle = widget.kind == SettingRowKind.toggle;
    final iconColor = widget.destructive ? palette.danger : palette.accentDark;
    final tileColor = widget.destructive ? palette.dangerTile : palette.tile;
    final titleColor = widget.destructive ? palette.danger : palette.title;
    const radius = BorderRadius.all(
      Radius.circular(SettingsPalette.cardRadius),
    );

    return Semantics(
      button: true,
      toggled: isToggle ? widget.isOn : null,
      liveRegion: true,
      label: widget.semanticLabel,
      hint: widget.hint,
      onTap: widget.onTap,
      onDidGainAccessibilityFocus: () => _highlight(true),
      onDidLoseAccessibilityFocus: () => _highlight(false),
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onFocusChange: _highlight,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            constraints: const BoxConstraints(
              minHeight: SettingsPalette.rowMinHeight,
            ),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: _highlighted ? palette.tile : Colors.transparent,
              borderRadius: radius,
              border: Border.all(
                color: _highlighted ? palette.accent : Colors.transparent,
                width: 3,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: SettingsPalette.tileSize,
                  height: SettingsPalette.tileSize,
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(
                      SettingsPalette.tileRadius,
                    ),
                  ),
                  child: Icon(widget.icon, color: iconColor, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: text.titleMedium?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.value,
                        style: text.bodyMedium?.copyWith(
                          color: palette.subtitle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (isToggle)
                  _Toggle(isOn: widget.isOn)
                else
                  Icon(Icons.chevron_right, color: palette.title, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Drawn by hand so it never looks "disabled"; the whole row is the button.
class _Toggle extends StatelessWidget {
  const _Toggle({required this.isOn});

  final bool isOn;

  @override
  Widget build(BuildContext context) {
    final palette = SettingsPalette.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 56,
      height: 32,
      padding: const EdgeInsets.all(3),
      alignment: isOn
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      decoration: BoxDecoration(
        color: isOn ? palette.accent : palette.toggleOff,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
