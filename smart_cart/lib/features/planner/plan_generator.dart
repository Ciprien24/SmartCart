import 'package:smart_cart/core/preferences.dart';
import 'package:smart_cart/core/shopping_item.dart';
import 'package:smart_cart/core/weekly_plan.dart';
import 'mock_products.dart';

class PlanGenerator {
  WeeklyPlan generate(Preferences prefs) {
    // 1) filter by store
    final products = mockProducts
        .where((p) => p.store == prefs.supermarket)
        .toList();
    if (products.isEmpty) {
      // fallback: if store doesn't match mock list, just use all
      products.addAll(mockProducts);
    }

    // 2) simple budget fill: add items until budget is reached
    final items = <ShoppingItem>[];
    double running = 0.0;

    // naive strategy: cheaper items first (helps hit budget)
    products.sort((a, b) => a.price.compareTo(b.price));

    for (final p in products) {
      if (running + p.price > prefs.budgetWeekly) continue;
      items.add(ShoppingItem(product: p, quantity: 1));
      running += p.price;

      // stop early if we are close enough (avoid micro-adding)
      if (prefs.budgetWeekly - running < 1.0) break;
    }

    final monday = _startOfWeek(DateTime.now());

    return WeeklyPlan(weekStart: monday, items: items);
  }

  DateTime _startOfWeek(DateTime d) {
    // Monday as start
    final diff = (d.weekday - DateTime.monday) % 7;
    return DateTime(d.year, d.month, d.day).subtract(Duration(days: diff));
  }
}
