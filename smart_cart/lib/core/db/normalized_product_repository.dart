import 'package:isar/isar.dart';
import 'package:smart_cart/core/db/collections/normalized_product_entity.dart';
import 'package:smart_cart/core/db/isar_db.dart';
import 'package:smart_cart/core/db/normalized_product_mapper.dart';
import 'package:smart_cart/core/normalization/normalized_product.dart';

class NormalizedProductRepository {
  Future<void> replaceAllForStore(
    String store,
    List<NormalizedProduct> products,
  ) async {
    final isar = await IsarDb.instance();
    final now = DateTime.now();
    final entities = products
        .map((product) => NormalizedProductMapper.toEntity(product, updatedAt: now))
        .toList();

    await isar.writeTxn(() async {
      final existing = await isar.normalizedProductEntitys
          .filter()
          .storeEqualTo(store)
          .findAll();
      await isar.normalizedProductEntitys.deleteAll(
        existing.map((item) => item.id).toList(),
      );
      if (entities.isNotEmpty) {
        await isar.normalizedProductEntitys.putAll(entities);
      }
    });
  }

  Future<List<NormalizedProductEntity>> getAllForStore(String store) async {
    final isar = await IsarDb.instance();
    return isar.normalizedProductEntitys
        .filter()
        .storeEqualTo(store)
        .sortByName()
        .findAll();
  }

  Future<List<NormalizedProductEntity>> getByNormalizedCategory(
    String store,
    String normalizedCategory,
  ) async {
    final isar = await IsarDb.instance();
    return isar.normalizedProductEntitys
        .filter()
        .storeEqualTo(store)
        .and()
        .normalizedCategoryEqualTo(normalizedCategory)
        .sortByPrice()
        .findAll();
  }
}
