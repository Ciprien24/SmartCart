import 'package:isar/isar.dart';

import 'cached_product_entity.dart';

part 'product_cache_entity.g.dart';

@collection
class ProductCacheEntity {
  Id id = Isar.autoIncrement;

  String storeKey = '';
  String? fetchedAt;
  DateTime savedAt = DateTime.now();
  List<CachedProductEntity> products = [];
}
