import 'package:smart_cart/core/preferences.dart';
import 'package:smart_cart/core/product.dart';
import 'package:smart_cart/core/shopping_item.dart';
import 'package:smart_cart/core/weekly_plan.dart';
import 'mock_products.dart';

class PlanGenerator {
  WeeklyPlan generate(Preferences prefs) {
    return generateFromProducts(prefs, mockProducts);
  }

  WeeklyPlan generateFromProducts(Preferences prefs, List<Product> products) {
    // 1) filter by store
    final selectedStore = prefs.supermarket.toLowerCase();
    final filteredProducts = products
        .where((p) => p.store.toLowerCase() == selectedStore)
        .toList();
    final sourceProducts = filteredProducts.isNotEmpty || selectedStore == 'lidl'
        ? filteredProducts
        : products.toList();

    // 2) simple budget fill: add items until budget is reached
    final items = <ShoppingItem>[];
    double running = 0.0;

    // naive strategy: cheaper items first (helps hit budget)
    sourceProducts.sort((a, b) => a.price.compareTo(b.price));

    for (final p in sourceProducts) {
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
