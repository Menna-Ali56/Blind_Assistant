const String _openPrefix = 'open.';
const String settingsCommandName = 'settings';

/// Builds the shared id of an open command from a screen name
String openCommandId(String name) => '$_openPrefix$name';
