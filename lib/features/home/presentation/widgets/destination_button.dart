import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/navigation/app_destination.dart';

class DestinationButton extends StatelessWidget {
  const DestinationButton({super.key, required this.destination});

  final AppDestination destination;

  @override
  Widget build(BuildContext context) {
    void open() => context.go(destination.path);
    return FilledButton.icon(
      onPressed: open,
      icon: Icon(destination.icon),
      label: Text(destination.label),
    ).asButton(label: destination.label, hint: destination.hint, onTap: open);
  }
}
