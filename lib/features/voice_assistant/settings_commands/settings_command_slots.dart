abstract final class SettingsCommandSlots {
  static const String state = 'state';
  static const String on = 'on';
  static const String off = 'off';

  static const Map<String, bool> wantedStates = {on: true, off: false};

  static bool shouldFlip(Map<String, String> slots, {required bool current}) {
    final slot = slots[state];
    if (slot == null) return true;
    final wanted = wantedStates[slot];
    return wanted != null && wanted != current;
  }
}
