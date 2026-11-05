import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

enum AppDestination {
  home(
    path: '/home',
    label: AppStrings.homeLabel,
    hint: AppStrings.homeHint,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  read(
    path: '/read',
    label: AppStrings.readLabel,
    hint: AppStrings.readHint,
    icon: Icons.menu_book_outlined,
    selectedIcon: Icons.menu_book,
  ),
  detect(
    path: '/detect',
    label: AppStrings.detectLabel,
    hint: AppStrings.detectHint,
    icon: Icons.center_focus_strong_outlined,
    selectedIcon: Icons.center_focus_strong,
  ),
  assistant(
    path: '/assistant',
    label: AppStrings.assistantLabel,
    hint: AppStrings.assistantHint,
    icon: Icons.mic_none,
    selectedIcon: Icons.mic,
  );

  const AppDestination({
    required this.path,
    required this.label,
    required this.hint,
    required this.icon,
    required this.selectedIcon,
  });

  final String path;
  final String label;
  final String hint;
  final IconData icon;
  final IconData selectedIcon;

  static const AppDestination initial = home;

  static List<AppDestination> get shortcuts =>
      values.where((item) => item != initial).toList(growable: false);
}
