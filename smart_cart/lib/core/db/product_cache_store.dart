import 'package:smart_cart/core/db/normalized_product_repository.dart';
import 'package:smart_cart/core/db/collections/product_cache_entity.dart';
import 'package:smart_cart/core/db/product_cache_mapper.dart';
import 'package:smart_cart/core/db/product_cache_repository.dart';
import 'package:smart_cart/core/normalization/product_normalizer.dart';
import 'package:smart_cart/core/product.dart';

class ProductCacheStore {
  ProductCacheStore({
    ProductCacheRepository? repository,
    NormalizedProductRepository? normalizedRepository,
  }) : _repository = repository ?? ProductCacheRepository(),
       _normalizedRepository =
           normalizedRepository ?? NormalizedProductRepository();

  final ProductCacheRepository _repository;
  final NormalizedProductRepository _normalizedRepository;

  Future<List<Product>> getCachedProducts(String storeKey) async {
    final cache = await _repository.getLatestForStore(storeKey);
    if (cache == null) {
      return const [];
    }
    return ProductCacheMapper.toProducts(cache.products);
  }

  Future<void> saveCachedProducts(
    String storeKey,
    String? fetchedAt,
    List<Product> products,
  ) async {
    final cache = ProductCacheEntity()
      ..storeKey = storeKey
      ..fetchedAt = fetchedAt
      ..savedAt = DateTime.now()
      ..products = ProductCacheMapper.toCachedEntities(products);
    await _repository.upsertStoreCache(cache);
    final normalizedProducts = normalizeProducts(products);
    await _normalizedRepository.replaceAllForStore(storeKey, normalizedProducts);
  }
}
