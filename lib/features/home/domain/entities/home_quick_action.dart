import 'package:flutter/material.dart';

import '../../../../core/navigation/app_destination.dart';
import '../../presentation/texts/home_texts.dart';

enum HomeTone { teal, blue, purple, coral, amber, green }

class HomeQuickAction {
  const HomeQuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
    required this.destination,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final HomeTone tone;
  final AppDestination destination;
}

const List<HomeQuickAction> homeQuickActions = [
  HomeQuickAction(
    title: HomeTexts.identifyObjectsTitle,
    subtitle: HomeTexts.identifyObjectsSubtitle,
    icon: Icons.camera_alt_outlined,
    tone: HomeTone.teal,
    destination: AppDestination.detect,
  ),
  HomeQuickAction(
    title: HomeTexts.readTextTitle,
    subtitle: HomeTexts.readTextSubtitle,
    icon: Icons.text_fields,
    tone: HomeTone.blue,
    destination: AppDestination.read,
  ),
  HomeQuickAction(
    title: HomeTexts.recognizeMoneyTitle,
    subtitle: HomeTexts.recognizeMoneySubtitle,
    icon: Icons.account_balance_wallet_outlined,
    tone: HomeTone.purple,
    destination: AppDestination.detect,
  ),
  HomeQuickAction(
    title: HomeTexts.detectColorsTitle,
    subtitle: HomeTexts.detectColorsSubtitle,
    icon: Icons.palette_outlined,
    tone: HomeTone.coral,
    destination: AppDestination.detect,
  ),
  HomeQuickAction(
    title: HomeTexts.readExpressionsTitle,
    subtitle: HomeTexts.readExpressionsSubtitle,
    icon: Icons.sentiment_satisfied_alt_outlined,
    tone: HomeTone.amber,
    destination: AppDestination.detect,
  ),
  HomeQuickAction(
    title: HomeTexts.safeNavigationTitle,
    subtitle: HomeTexts.safeNavigationSubtitle,
    icon: Icons.route_outlined,
    tone: HomeTone.green,
    destination: AppDestination.detect,
  ),
];
