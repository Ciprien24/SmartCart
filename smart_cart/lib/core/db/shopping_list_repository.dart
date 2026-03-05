import 'package:isar/isar.dart';
import 'package:smart_cart/core/db/collections/shopping_list_entity.dart';
import 'package:smart_cart/core/db/isar_db.dart';

class ShoppingListRepository {
  Future<int> save(ShoppingListEntity list) async {
    final isar = await IsarDb.instance();
    return isar.writeTxn(() async {
      return isar.shoppingListEntitys.put(list);
    });
  }

  Future<List<ShoppingListEntity>> getAll() async {
    final isar = await IsarDb.instance();
    return isar.shoppingListEntitys
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<ShoppingListEntity?> getById(int id) async {
    final isar = await IsarDb.instance();
    return isar.shoppingListEntitys.get(id);
  }

  Future<void> deleteById(int id) async {
    final isar = await IsarDb.instance();
    await isar.writeTxn(() async {
      await isar.shoppingListEntitys.delete(id);
    });
  }
}

// Example usage snippets (no UI refactor required):
//
// 1) Save after generating a list (e.g. in PreferencesScreen after plan generation):
// final repo = ShoppingListRepository();
// final entity = ShoppingListEntity()
//   ..title = 'Weekly List'
//   ..createdAt = DateTime.now()
//   ..store = preferences.supermarket
//   ..goal = preferences.goal
//   ..budget = preferences.budgetWeekly
//   ..items = plan.items.map((it) {
//     final e = ShoppingItemEntity()
//       ..name = it.product.name
//       ..price = it.product.price
//       ..quantity = it.quantity
//       ..checked = it.checked
//       ..category = it.product.category;
//     return e;
//   }).toList();
// await repo.save(entity);
//
// 2) Load all lists on carts page:
// final repo = ShoppingListRepository();
// final lists = await repo.getAll();
