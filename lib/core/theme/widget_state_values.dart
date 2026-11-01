import 'package:flutter/material.dart';

WidgetStateProperty<T> valueWhen<T>(
  WidgetState state, {
  required T yes,
  required T otherwise,
}) {
  return WidgetStateProperty.resolveWith(
    (states) => states.contains(state) ? yes : otherwise,
  );
}
