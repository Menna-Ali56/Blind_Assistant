import 'package:baseer/core/accessibility/semantics_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpWidget(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  late SemanticsHandle handle;

  setUp(() {
    handle = TestWidgetsFlutterBinding.ensureInitialized().ensureSemantics();
  });
  tearDown(() => handle.dispose());

  testWidgets('asButton reads one label and exposes tap', (tester) async {
    var taps = 0;
    await pumpWidget(
      tester,
      const Text('camera icon').asButton(label: 'Scan', onTap: () => taps++),
    );
    final node = tester.getSemantics(find.bySemanticsLabel('Scan'));
    final data = node.getSemanticsData();
    expect(data.label, 'Scan');
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.bySemanticsLabel('camera icon'), findsNothing);
    expect(taps, 0);
  });

  testWidgets('labeled replaces the child text', (tester) async {
    await pumpWidget(tester, const Text('icon').labeled('History card'));
    expect(find.bySemanticsLabel('History card'), findsOneWidget);
    expect(find.bySemanticsLabel('icon'), findsNothing);
  });

  testWidgets('decorative removes the node', (tester) async {
    await pumpWidget(tester, const Text('emoji').decorative());
    expect(find.bySemanticsLabel('emoji'), findsNothing);
  });

  testWidgets('asHeader keeps the child text', (tester) async {
    await pumpWidget(tester, const Text('Settings').asHeader());
    expect(find.bySemanticsLabel('Settings'), findsOneWidget);
  });
}
