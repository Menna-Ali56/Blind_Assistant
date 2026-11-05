import 'package:baseer/core/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('title is a live header that names the screen', (tester) async {
    const title = 'Title';
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: ScreenScaffold(title: title, child: SizedBox.shrink()),
      ),
    );
    expect(
      tester.getSemantics(find.text(title)),
      isSemantics(label: title, isHeader: true, isLiveRegion: true),
    );
    handle.dispose();
  });
}
