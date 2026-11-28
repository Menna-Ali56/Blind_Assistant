import 'package:flutter/material.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/constants/app_dimens.dart';

class CameraActionButton extends StatelessWidget {
  const CameraActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final child = Text(label);
    final button = primary
        ? FilledButton(onPressed: onTap, child: child)
        : OutlinedButton(onPressed: onTap, child: child);
    return SizedBox(
      height: AppDimens.buttonHeight,
      child: button,
    ).asButton(label: label, onTap: onTap);
  }
}
