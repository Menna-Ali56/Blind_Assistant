import 'package:baseer/core/feedback/shared_audio_focus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../output/output_test_support.dart';

void main() {
  test('inner focus is taken once and freed by the last holder', () async {
    final inner = FakeAudioFocus();
    final shared = SharedAudioFocus(inner);
    await shared.acquire();
    await shared.acquire();
    await shared.release();
    expect(inner.events, ['acquire']);
    await shared.release();
    expect(inner.events, ['acquire', 'release']);
  });

  test('extra release does nothing', () async {
    final inner = FakeAudioFocus();
    await SharedAudioFocus(inner).release();
    expect(inner.events, isEmpty);
  });
}
