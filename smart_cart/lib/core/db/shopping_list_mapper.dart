import 'package:smart_cart/core/db/collections/shopping_item_entity.dart';
import 'package:smart_cart/core/db/collections/shopping_list_entity.dart';
import 'package:smart_cart/core/preferences.dart';
import 'package:smart_cart/core/product.dart';
import 'package:smart_cart/core/shopping_item.dart';
import 'package:smart_cart/core/weekly_plan.dart';

class ShoppingListDomainModel {
  final WeeklyPlan plan;
  final Preferences preferences;

  const ShoppingListDomainModel({
    required this.plan,
    required this.preferences,
  });
}

class ShoppingListMapper {
  ShoppingListMapper._();

  static ShoppingListEntity toEntity({
    required WeeklyPlan plan,
    required Preferences preferences,
    String? fetchedAt,
    DateTime? now,
  }) {
    final created = now ?? DateTime.now();

    return ShoppingListEntity()
      ..title = '${preferences.supermarket} • ${_formatDate(created)}'
      ..createdAt = created
      ..store = preferences.supermarket
      ..multipleStores = preferences.selectedSupermarkets.length > 1
      ..selectedStores = List<String>.from(preferences.selectedSupermarkets)
      ..goal = preferences.goal
      ..budget = preferences.budgetWeekly
      ..shoppingDays = preferences.shoppingDays
      ..fetchedAt = fetchedAt
      ..items = plan.items.map((item) {
        return ShoppingItemEntity()
          ..name = item.product.name
          ..price = item.product.price
          ..quantity = item.quantity
          ..checked = item.checked
          ..category = item.product.category
          ..unit = _inferUnit(item.product.name);
      }).toList();
  }

  static ShoppingListDomainModel toDomain(ShoppingListEntity entity) {
    final store = entity.store ?? 'Lidl';
    final selectedStores = entity.selectedStores.isNotEmpty
        ? entity.selectedStores
        : [store];

    final planItems = entity.items.map((item) {
      final product = Product(
        id: item.unit == null || item.unit!.isEmpty
            ? item.name
            : '${item.name}-${item.unit}',
        name: item.name,
        category: item.category ?? 'Other',
        price: item.price,
        store: store,
      );

      return ShoppingItem(
        product: product,
        quantity: item.quantity,
        checked: item.checked,
      );
    }).toList();

    return ShoppingListDomainModel(
      plan: WeeklyPlan(
        weekStart: entity.createdAt,
        items: planItems,
      ),
      preferences: Preferences(
        budgetWeekly: entity.budget ?? 0,
        supermarket: store,
        supermarkets: List<String>.from(selectedStores),
        goal: entity.goal ?? 'Maintain',
        shoppingDays: entity.shoppingDays,
      ),
    );
  }

  static String _formatDate(DateTime value) {
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String? _inferUnit(String productName) {
    const unitMap = {
      'Chicken breast 1kg': '500g',
      'Greek yogurt 1kg': '250g',
      'Eggs 10 pcs': '10 pack',
      'Oats 1kg': '500g',
      'Rice 1kg': '1kg',
      'Pasta 1kg': '500g',
      'Bananas 1kg': '1kg',
      'Apples 1kg': '1kg',
      'Tomatoes 1kg': '1kg',
      'Frozen veggies 1kg': '500g',
      'Olive oil 500ml': '500ml',
      'Peanut butter 500g': '250g',
    };
    return unitMap[productName];
  }
}
