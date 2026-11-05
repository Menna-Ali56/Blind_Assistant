import 'package:flutter/material.dart';

import '../accessibility/semantics_extension.dart';

class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title,
      child: Scaffold(
        appBar: AppBar(title: Text(title).asHeader().asLiveRegion()),
        body: SafeArea(child: child),
      ),
    );
  }
}
