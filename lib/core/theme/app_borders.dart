class AppBorders {
  const AppBorders({required this.card, required this.control});

  final double card;
  final double control;

  static const standard = AppBorders(card: 2, control: 3);
  static const highContrast = AppBorders(card: 3, control: 4);
}
