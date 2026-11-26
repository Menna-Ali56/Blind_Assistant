import '../../../../core/inference/mobile_action.dart';
import '../../../../core/navigation/app_destination.dart';
import '../../domain/catalog/command_catalog.dart';
import '../../domain/entities/command_locale.dart';
import '../../domain/entities/slot_keys.dart';
import '../../navigation_commands/navigation_command_ids.dart';
import '../../settings_commands/settings_command_ids.dart';

KeywordGroup _g(
  String id,
  List<String> ar,
  List<String> en, [
  Map<String, String> slots = const {},
]) => KeywordGroup(
  id: id,
  phrases: {CommandLocale.arEg: ar, CommandLocale.enUs: en},
  slots: slots,
);

List<KeywordGroup> _toggle(
  String id,
  List<String> ar,
  List<String> en,
  List<String> arOn,
  List<String> enOn,
  List<String> arOff,
  List<String> enOff,
) => [
  _g(id, ar, en),
  _g(id, arOn, enOn, const {SlotKeys.state: SlotKeys.on}),
  _g(id, arOff, enOff, const {SlotKeys.state: SlotKeys.off}),
];

abstract final class CommandKeywords {
  static const String wakeId = 'wake';

  static final List<KeywordGroup> table = [
    _g(wakeId, const ['يا بصير'], const ['hey baseer']),
    _g(
      openCommandId(AppDestination.home.name),
      const ['الرئيسية', 'افتح الرئيسية'],
      const ['open home', 'go home'],
    ),
    _g(
      openCommandId(AppDestination.read.name),
      const ['القراءة', 'افتح القراءة'],
      const ['open read', 'open reading'],
    ),
    _g(
      openCommandId(AppDestination.detect.name),
      const ['الاكتشاف', 'افتح الكشف'],
      const ['open detect', 'open detection'],
    ),
    _g(
      openCommandId(AppDestination.assistant.name),
      const ['المساعد', 'افتح المساعد'],
      const ['open assistant'],
    ),
    _g(
      openCommandId(settingsCommandName),
      const ['الاعدادات', 'افتح الاعدادات'],
      const ['open settings', 'settings'],
    ),
    _g(
      SettingsCommandIds.voiceRateCycle,
      const ['سرعة الصوت', 'غير سرعة الكلام'],
      const ['cycle voice speed', 'change voice rate'],
    ),
    _g(
      SettingsCommandIds.textSizeCycle,
      const ['حجم الخط', 'كبر الخط'],
      const ['cycle text size', 'change text size'],
    ),
    ..._toggle(
      SettingsCommandIds.highContrastToggle,
      const ['التباين العالي'],
      const ['toggle high contrast'],
      const ['شغل التباين العالي'],
      const ['turn on high contrast'],
      const ['اقفل التباين العالي'],
      const ['turn off high contrast'],
    ),
    ..._toggle(
      SettingsCommandIds.hapticsToggle,
      const ['الاهتزاز'],
      const ['toggle haptics'],
      const ['شغل الاهتزاز'],
      const ['turn on haptics'],
      const ['اقفل الاهتزاز'],
      const ['turn off haptics'],
    ),
    ..._toggle(
      SettingsCommandIds.wakeWordToggle,
      const ['كلمة التنبيه'],
      const ['toggle wake word'],
      const ['شغل كلمة التنبيه'],
      const ['turn on wake word'],
      const ['اقفل كلمة التنبيه'],
      const ['turn off wake word'],
    ),
    _g(
      MobileAction.openCameraOcr.code,
      const ['اقرا', 'اقرا الورقة'],
      const ['read', 'read document'],
    ),
    _g(
      MobileAction.openCameraCurrency.code,
      const ['عملة', 'فلوس'],
      const ['currency', 'money'],
    ),
    _g(
      MobileAction.openCameraDescribe.code,
      const ['وصف المكان', 'ايه حواليا'],
      const ['describe scene', 'what is around me'],
    ),
    _g(
      MobileAction.openCameraColor.code,
      const ['لون', 'ايه اللون'],
      const ['color', 'what color'],
    ),
    _g(
      MobileAction.openCameraTrafficSign.code,
      const ['اشارة', 'لافتة'],
      const ['traffic sign', 'read sign'],
    ),
    _g(
      MobileAction.openCameraObstacle.code,
      const ['عائق', 'في ايه قدامي'],
      const ['obstacle', 'what is ahead'],
    ),
    _g(
      MobileAction.openCameraExpression.code,
      const ['تعبير الوش', 'ملامح'],
      const ['expression', 'face expression'],
    ),
    _g(
      MobileAction.openCameraQr.code,
      const ['جوه المبنى', 'ملاحة داخلية'],
      const ['indoor', 'indoor navigation'],
    ),
  ];

  static final List<String> allIds = table
      .map((g) => g.id)
      .toSet()
      .toList(growable: false);

  static final List<String> commandIds = allIds
      .where((id) => id != wakeId)
      .toList(growable: false);
}
