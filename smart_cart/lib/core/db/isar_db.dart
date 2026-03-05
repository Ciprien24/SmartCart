import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'collections/product_cache_entity.dart';
import 'collections/shopping_list_entity.dart';

class IsarDb {
  IsarDb._();

  static Isar? _isar;

  static Future<Isar> instance() async {
    if (_isar != null) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ShoppingListEntitySchema, ProductCacheEntitySchema],
      directory: dir.path,
      name: 'smartcart_db',
    );
    return _isar!;
  }
}
