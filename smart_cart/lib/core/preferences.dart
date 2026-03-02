class Preferences {
  final double budgetWeekly;
  final String supermarket; // Lidl/Kaufland/Carrefour/etc
  final String goal; // "Lose weight" / "Gain muscle" / "Maintain"

  const Preferences({
    required this.budgetWeekly,
    required this.supermarket,
    required this.goal,
  });
}
