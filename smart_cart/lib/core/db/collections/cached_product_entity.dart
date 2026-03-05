import 'package:isar/isar.dart';

part 'cached_product_entity.g.dart';

@embedded
class CachedProductEntity {
  String? id;
  String name = '';
  double price = 0;
  String? category;
  String? unit;
  String store = '';
}
