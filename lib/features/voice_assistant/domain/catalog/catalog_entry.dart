import 'package:equatable/equatable.dart';

import '../entities/command_locale.dart';
import '../entities/slot_keys.dart';

class CatalogEntry extends Equatable {
  const CatalogEntry({
    required this.id,
    required this.locale,
    this.slots = const {},
  });

  final String id;
  final CommandLocale locale;
  final Map<String, String> slots;

  Map<String, String> get resolvedSlots => {
    SlotKeys.locale: locale.code,
    ...slots,
  };

  @override
  List<Object> get props => [id, locale, slots];
}
