import 'package:baseer/core/navigation/app_destination.dart';
import 'package:baseer/core/navigation/router_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget _page(AppDestination destination) => Text('page ${destination.name}');

Future<GoRouter> _pump(WidgetTester tester) async {
  final router = buildRouter(_page);
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  return router;
}

void main() {
  testWidgets('starts on the initial destination', (tester) async {
    await _pump(tester);
    expect(find.text('page ${AppDestination.initial.name}'), findsOneWidget);
  });

  testWidgets('every destination opens from the bar', (tester) async {
    await _pump(tester);
    for (final item in AppDestination.values) {
      await tester.tap(find.text(item.label));
      await tester.pumpAndSettle();
      expect(find.text('page ${item.name}'), findsOneWidget);
    }
  });

  testWidgets('unknown location goes back to the initial one', (tester) async {
    final router = await _pump(tester);
    router.go('/missing');
    await tester.pumpAndSettle();
    expect(find.text('page ${AppDestination.initial.name}'), findsOneWidget);
  });
}
