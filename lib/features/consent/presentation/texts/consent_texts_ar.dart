import '../../../../core/consent/consent_scope.dart';
import 'consent_texts.dart';

const ConsentTexts arabicConsentTexts = ConsentTexts(
  labels: {
    ConsentScope.imageUpload: 'إرسال الصور للسحابة',
    ConsentScope.audioUpload: 'إرسال الصوت للسحابة',
    ConsentScope.locationShare: 'مشاركة الموقع للملاحة',
  },
  purposes: {
    ConsentScope.imageUpload:
        'يسمح لبصير بإرسال صور عند الحاجة لقراءة المستندات أو وصف المشهد '
        'أو الإجابة عن سؤالك.',
    ConsentScope.audioUpload:
        'يسمح لبصير بإرسال الصوت لفهم الأسئلة والمحادثات الأكثر تعقيداً.',
    ConsentScope.locationShare:
        'يسمح لبصير بمشاركة موقعك أثناء الملاحة لإرشادك في الطريق.',
  },
  title: 'موافقة الخصوصية',
  allowAction: 'سماح',
  notNowAction: 'ليس الآن',
  allowHint: 'اضغط على سماح أو ليس الآن للمتابعة.',
  doneMessage: 'تم حفظ اختيارات الخصوصية.',
);
