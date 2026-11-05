import 'package:flutter/widgets.dart';

extension AppMotion on BuildContext {
  Duration motion(Duration normal) {
    return MediaQuery.disableAnimationsOf(this) ? Duration.zero : normal;
  }
}
