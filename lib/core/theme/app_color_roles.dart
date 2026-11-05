import 'package:flutter/material.dart';

extension AppColorRoles on ColorScheme {
  Color get muted => onSurfaceVariant;
  Color get raised => surfaceContainer;
  Color get raisedHigh => surfaceContainerHighest;
  Color get border => outline;
  Color get borderSoft => outlineVariant;
  Color get focus => tertiary;
  Color get warning => tertiary;
  Color get warningContainer => tertiaryContainer;
  Color get positiveContainer => primaryContainer;
  Color get danger => error;
  Color get dangerContainer => errorContainer;
}
