import 'package:flutter/material.dart';

import 'core/accessibility/text_scale_builder.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const BlindApp());
}

class BlindApp extends StatelessWidget {
  const BlindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blind App',
      theme: AppTheme.standard,
      highContrastTheme: AppTheme.highContrast,
      builder: appTextScaleBuilder,
      home: const Scaffold(
        body: Center(child: Text('Welcome to the Blind App')),
      ),
    );
  }
}
