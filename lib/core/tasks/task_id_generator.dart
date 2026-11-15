import 'dart:math';

abstract interface class TaskIdGenerator {
  String next();
}

/// Makes random version 4 ids that match the backend uuid columns
class UuidV4Generator implements TaskIdGenerator {
  UuidV4Generator({Random? random}) : _random = random ?? Random.secure();

  static const int _byteCount = 16;
  static const int _byteRange = 256;
  static const int _versionIndex = 6;
  static const int _variantIndex = 8;
  static const int _versionMask = 0x0f;
  static const int _versionBits = 0x40;
  static const int _variantMask = 0x3f;
  static const int _variantBits = 0x80;
  static const int _hexRadix = 16;
  static const int _hexWidth = 2;
  static const String _separator = '-';
  static const Set<int> _separatorBefore = {4, 6, 8, 10};

  final Random _random;

  @override
  String next() {
    final bytes = List<int>.generate(
      _byteCount,
      (_) => _random.nextInt(_byteRange),
    );
    bytes[_versionIndex] = (bytes[_versionIndex] & _versionMask) | _versionBits;
    bytes[_variantIndex] = (bytes[_variantIndex] & _variantMask) | _variantBits;
    return _format(bytes);
  }

  String _format(List<int> bytes) {
    final buffer = StringBuffer();
    for (var i = 0; i < bytes.length; i++) {
      if (_separatorBefore.contains(i)) buffer.write(_separator);
      buffer.write(bytes[i].toRadixString(_hexRadix).padLeft(_hexWidth, '0'));
    }
    return buffer.toString();
  }
}
