import '../../../../core/inference/coded_enum.dart';

enum CommandLocale implements CodedEnum {
  arEg('ar-EG'),
  enUs('en-US');

  const CommandLocale(this.code);

  @override
  final String code;
}
