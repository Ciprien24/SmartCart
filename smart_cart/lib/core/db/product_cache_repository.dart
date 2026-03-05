import 'package:isar/isar.dart';
import 'package:smart_cart/core/db/collections/product_cache_entity.dart';
import 'package:smart_cart/core/db/isar_db.dart';

class ProductCacheRepository {
  Future<ProductCacheEntity?> getLatestForStore(String storeKey) async {
    final isar = await IsarDb.instance();
    return isar.productCacheEntitys
        .filter()
        .storeKeyEqualTo(storeKey)
        .sortBySavedAtDesc()
        .findFirst();
  }

  Future<void> upsertStoreCache(ProductCacheEntity cache) async {
    final isar = await IsarDb.instance();
    await isar.writeTxn(() async {
      final existing = await isar.productCacheEntitys
          .filter()
          .storeKeyEqualTo(cache.storeKey)
          .findFirst();
      if (existing != null) {
        cache.id = existing.id;
      }
      await isar.productCacheEntitys.put(cache);
    });
  }

  Future<void> clearStore(String storeKey) async {
    final isar = await IsarDb.instance();
    await isar.writeTxn(() async {
      final toDelete = await isar.productCacheEntitys
          .filter()
          .storeKeyEqualTo(storeKey)
          .findAll();
      final ids = toDelete.map((item) => item.id).toList();
      await isar.productCacheEntitys.deleteAll(ids);
    });
  }
}
