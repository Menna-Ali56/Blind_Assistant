import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/widgets/error_retry_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester,
  String code, {
  VoidCallback? onSignIn,
  bool canRetryAgain = true,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ErrorRetryView(
          error: ApiFailure.fromCode(code),
          onRetry: () {},
          onSignIn: onSignIn,
          canRetryAgain: canRetryAgain,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('new capture failure shows a start again button', (tester) async {
    await _pump(tester, 'ERR_IMAGE_BLURRY');

    expect(find.text('Start again'), findsOneWidget);
  });

  testWidgets('failure without retry shows no button', (tester) async {
    await _pump(tester, 'ERR_FORBIDDEN');

    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('login failure shows sign in when a callback exists', (
    tester,
  ) async {
    await _pump(tester, 'ERR_UNAUTHORIZED', onSignIn: () {});

    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('same request button hides after the retry limit', (
    tester,
  ) async {
    await _pump(tester, 'ERR_REQUEST_TIMEOUT', canRetryAgain: false);

    expect(find.byType(FilledButton), findsNothing);
  });
}
