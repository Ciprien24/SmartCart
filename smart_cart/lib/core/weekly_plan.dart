import 'shopping_item.dart';

class WeeklyPlan {
  final DateTime weekStart;
  final List<ShoppingItem> items;

  WeeklyPlan({required this.weekStart, required this.items});

  double get totalEstimated =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);
}
