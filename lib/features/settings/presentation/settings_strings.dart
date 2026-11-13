import '../domain/entities/app_settings.dart';
import 'cubit/text_size_step.dart';

class SettingsStrings {
  SettingsStrings.of(String languageCode)
    : _isArabic = languageCode.toLowerCase().startsWith('ar'),
      _t = languageCode.toLowerCase().startsWith('ar') ? _ar : _en;

  final bool _isArabic;
  final Map<String, String> _t;

  String _s(String key) => _t[key]!;

  String get title => _s('title');
  String get eyebrow => _s('eyebrow');
  String get sectionAccessibility => _s('sectionAccessibility');
  String get sectionPreferences => _s('sectionPreferences');
  String get sectionPrivacy => _s('sectionPrivacy');
  String get loading => _s('loading');
  String get voiceRate => _s('voiceRate');
  String get textSize => _s('textSize');
  String get highContrast => _s('highContrast');
  String get haptics => _s('haptics');
  String get wakeWord => _s('wakeWord');
  String get imageUpload => _s('imageUpload');
  String get deleteData => _s('deleteData');
  String get deleteValue => _s('deleteValue');
  String get changeHint => _s('changeHint');
  String get deleteHint => _s('deleteHint');
  String get deleteTitle => _s('deleteTitle');
  String get deleteMessage => _s('deleteMessage');
  String get deleteConfirm => _s('deleteConfirm');
  String get deleteCancel => _s('deleteCancel');
  String get deletedTitle => _s('deletedTitle');
  String get deletedMessage => _s('deletedMessage');
  String get back => _s('back');
  String get goBack => _s('goBack');

  String voiceRateValue(VoiceRate rate) => _s('rate_${rate.name}');

  String textSizeValue(TextSizeStep step) => _s('size_${step.name}');

  String onOff(bool value) => _s(value ? 'on' : 'off');

  String allowed(bool value) => _s(value ? 'allowed' : 'notAllowed');

  /// What a screen reader says for a row.
  String rowLabel(String label, String value) =>
      _isArabic ? '$label، $value' : '$label, $value';

  static const Map<String, String> _ar = {
    'title': 'الإعدادات',
    'eyebrow': 'الحساب والتفضيلات',
    'sectionAccessibility': 'إمكانية الوصول',
    'sectionPreferences': 'التفضيلات',
    'sectionPrivacy': 'الخصوصية والبيانات',
    'loading': 'جارٍ تحميل الإعدادات',
    'voiceRate': 'سرعة الصوت',
    'textSize': 'حجم الخط',
    'highContrast': 'التباين العالي',
    'haptics': 'الاهتزاز',
    'wakeWord': '«يا بصير»',
    'imageUpload': 'إرسال الصور',
    'deleteData': 'حذف بياناتي',
    'deleteValue': 'نقرتان',
    'changeHint': 'انقر مرتين للتغيير',
    'deleteHint': 'انقر مرتين للحذف',
    'rate_slow': 'بطيء',
    'rate_normal': 'عادي',
    'rate_fast': 'سريع',
    'size_normal': 'عادي',
    'size_large': 'كبير',
    'size_extraLarge': 'كبير جدًا',
    'on': 'مفعّل',
    'off': 'متوقف',
    'allowed': 'مسموح',
    'notAllowed': 'غير مسموح',
    'deleteTitle': 'حذف بياناتك؟',
    'deleteMessage':
        'سيتم مسح إعداداتك وبياناتك من هذا الجهاز. لا يمكن التراجع.',
    'deleteConfirm': 'احذف',
    'deleteCancel': 'إلغاء',
    'deletedTitle': 'تم المسح',
    'deletedMessage': 'تم مسح بياناتك من الجهاز.',
    'back': 'رجوع إلى الإعدادات',
    'goBack': 'رجوع',
  };

  static const Map<String, String> _en = {
    'title': 'Settings',
    'eyebrow': 'ACCOUNT & PREFERENCES',
    'sectionAccessibility': 'ACCESSIBILITY',
    'sectionPreferences': 'PREFERENCES',
    'sectionPrivacy': 'PRIVACY & DATA',
    'loading': 'Loading settings',
    'voiceRate': 'Voice speed',
    'textSize': 'Text size',
    'highContrast': 'High contrast',
    'haptics': 'Vibration',
    'wakeWord': '"Ya Baseer" voice trigger',
    'imageUpload': 'Send photos',
    'deleteData': 'Delete my data',
    'deleteValue': 'Double tap',
    'changeHint': 'Double tap to change',
    'deleteHint': 'Double tap to delete',
    'rate_slow': 'Slow',
    'rate_normal': 'Normal',
    'rate_fast': 'Fast',
    'size_normal': 'Normal',
    'size_large': 'Large',
    'size_extraLarge': 'Extra large',
    'on': 'On',
    'off': 'Off',
    'allowed': 'Allowed',
    'notAllowed': 'Not allowed',
    'deleteTitle': 'Delete your data?',
    'deleteMessage':
        'This removes your settings and data from this device. '
        'It cannot be undone.',
    'deleteConfirm': 'Delete',
    'deleteCancel': 'Cancel',
    'deletedTitle': 'Data deleted',
    'deletedMessage': 'Your data was removed from this device.',
    'back': 'Back to settings',
    'goBack': 'Back',
  };
}
