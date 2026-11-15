import 'coded_enum.dart';

enum FacialExpression implements CodedEnum {
  happy('HAPPY'),
  neutral('NEUTRAL'),
  sad('SAD'),
  surprised('SURPRISED'),
  angry('ANGRY'),
  unknown('');

  const FacialExpression(this.code);

  @override
  final String code;

  static FacialExpression fromCode(String? code) =>
      enumFromCode(values, code, unknown);
}
