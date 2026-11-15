import '../../../../core/errors/messages/error_messages_ar.dart';
import '../../domain/entities/permission_kind.dart';
import 'permission_texts.dart';

const PermissionTexts arabicPermissionTexts = PermissionTexts(
  labels: arabicPermissionLabels,
  purposes: {
    PermissionKind.camera:
        'يستخدم بصير الكاميرا لقراءة النصوص والتعرف على الأشياء والعملات '
        'من حولك. لا يتم إرسال شيء دون موافقتك.',
    PermissionKind.microphone:
        'يستخدم بصير الميكروفون لفهم أوامرك الصوتية. لا يتم حفظ صوتك.',
    PermissionKind.location: 'يستخدم بصير موقعك لإرشادك أثناء المشي.',
  },
  title: 'أذونات التطبيق',
  allowedTemplate: 'تم السماح بإذن {label}.',
  deniedTemplate: 'لم يتم السماح بإذن {label}. يمكنك المحاولة مرة أخرى.',
  blockedTemplate: 'إذن {label} مغلق. افتح إعدادات الهاتف للسماح به.',
  allowAction: 'سماح',
  notNowAction: 'ليس الآن',
  settingsAction: 'فتح الإعدادات',
  allowHint: 'اضغط على سماح للمتابعة.',
  doneMessage: 'الأذونات جاهزة.',
);
