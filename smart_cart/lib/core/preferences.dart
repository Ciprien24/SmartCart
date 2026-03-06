class Preferences {
  final double budgetWeekly;
  final String supermarket; // primary store used by current generator
  final List<String> supermarkets; // future AI comparison input
  final String goal; // "Lose weight" / "Gain muscle" / "Maintain"
  final int shoppingDays; // number of days the list should cover

  const Preferences({
    required this.budgetWeekly,
    required this.supermarket,
    this.supermarkets = const [],
    required this.goal,
    this.shoppingDays = 7,
  });

  List<String> get selectedSupermarkets =>
      supermarkets.isEmpty ? <String>[supermarket] : supermarkets;
}
