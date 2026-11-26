const String _labelSlot = '{label}';
const String _valueSlot = '{value}';

class SettingsCommandTexts {
  const SettingsCommandTexts({required this.changedTemplate});

  final String changedTemplate;

  String changed(String label, String value) => changedTemplate
      .replaceAll(_labelSlot, label)
      .replaceAll(_valueSlot, value);
}
