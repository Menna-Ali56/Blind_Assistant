import 'package:flutter/painting.dart';

abstract final class HomeTexts {
  static const String greetingEyebrow = 'MONDAY, 24 JUNE';
  static const String greetingTitle = 'Good morning, Alex.';
  static const String profileBadge = 'AM';
  static const String assistantTitle = 'How can I help?';
  static const String assistantSubtitle = 'Tap to speak with your assistant';
  static const String quickActionsEyebrow = 'QUICK ACTIONS';
  static const String quickActionsTitle = 'Explore your world';
  static const String recentLabel = 'Recent';
  static const String recentHint = 'Open recent reading and detection activity';

  static const String identifyObjectsTitle = 'Identify objects';
  static const String identifyObjectsSubtitle = "Know what's in front of you";
  static const String readTextTitle = 'Read text';
  static const String readTextSubtitle = 'Documents, labels and signs';
  static const String recognizeMoneyTitle = 'Recognize money';
  static const String recognizeMoneySubtitle = 'Identify notes instantly';
  static const String detectColorsTitle = 'Detect colors';
  static const String detectColorsSubtitle = 'Explore colors around you';
  static const String readExpressionsTitle = 'Read expressions';
  static const String readExpressionsSubtitle = 'Understand facial emotion';
  static const String safeNavigationTitle = 'Safe navigation';
  static const String safeNavigationSubtitle = 'Detect nearby obstacles';
}

abstract final class HomeDimens {
  static const double badgeSize = 52;
  static const double heroIconBox = 56;
  static const double cardIconBox = 44;
  static const double iconSize = 24;
  static const double arrowSize = 20;
  static const double sectionGap = 24;
  static const double gridSpacing = 14;
  static const double cardTitleTopGap = 22;
  static const double smallGap = 6;
  static const double tinyGap = 4;
  static const double eyebrowTracking = 1.2;
  static const double singleColumnScale = 1.35;
  static const int gridColumns = 2;

  static const EdgeInsets heroPadding = EdgeInsets.all(20);
  static const EdgeInsets cardPadding = EdgeInsets.all(18);
}
