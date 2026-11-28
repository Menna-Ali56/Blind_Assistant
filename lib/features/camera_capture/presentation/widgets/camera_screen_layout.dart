import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';

class CameraScreenLayout extends StatelessWidget {
  const CameraScreenLayout({
    super.key,
    required this.content,
    required this.message,
    required this.actions,
  });

  static const double controlsMaxShare = 0.6;

  final Widget content;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: AppDimens.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: content),
            const SizedBox(height: AppDimens.itemGap),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * controlsMaxShare,
              ),
              child: SingleChildScrollView(child: _controls(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        for (final action in actions) ...[
          const SizedBox(height: AppDimens.itemGap),
          action,
        ],
      ],
    );
  }
}
