import 'package:baseer/core/constants/app_strings.dart';
import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/widgets/error_retry_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Object error, VoidCallback onRetry) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ErrorRetryView(error: error, onRetry: onRetry),
      ),
    ),
  );
}

void main() {
  final retry = find.text(AppStrings.retryLabel);

  testWidgets('retryable error shows a working retry button', (tester) async {
    var taps = 0;
    await _pump(tester, const NetworkException(), () => taps++);
    await tester.tap(retry);
    expect(taps, 1);
  });

  testWidgets('blocked permission shows no retry button', (tester) async {
    await _pump(
      tester,
      const PermissionException(isPermanentlyDenied: true),
      () {},
    );
    expect(retry, findsNothing);
  });

  testWidgets('cancelled work shows nothing', (tester) async {
    await _pump(tester, const CancelledFailure(), () {});
    expect(find.byType(Text), findsNothing);
  });
}
