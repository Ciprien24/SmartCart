import 'package:isar/isar.dart';

part 'shopping_item_entity.g.dart';

@embedded
class ShoppingItemEntity {
  String name = '';
  double price = 0;
  int quantity = 1;
  bool checked = false;
  String? category;
  String? unit;
}
