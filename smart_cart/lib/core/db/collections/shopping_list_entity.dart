import 'package:isar/isar.dart';

import 'shopping_item_entity.dart';

part 'shopping_list_entity.g.dart';

@collection
class ShoppingListEntity {
  Id id = Isar.autoIncrement;

  String title = '';
  DateTime createdAt = DateTime.now();
  String? store;
  String? goal;
  double? budget;
  String? fetchedAt;

  List<ShoppingItemEntity> items = [];
}
