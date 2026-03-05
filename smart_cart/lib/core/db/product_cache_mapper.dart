import 'package:smart_cart/core/db/collections/cached_product_entity.dart';
import 'package:smart_cart/core/product.dart';

class ProductCacheMapper {
  ProductCacheMapper._();

  static List<CachedProductEntity> toCachedEntities(List<Product> products) {
    return products.map((product) {
      return CachedProductEntity()
        ..id = product.id
        ..name = product.name
        ..price = product.price
        ..category = product.category
        ..store = product.store;
    }).toList();
  }

  static List<Product> toProducts(List<CachedProductEntity> products) {
    return products.map((cached) {
      return Product(
        id: (cached.id == null || cached.id!.isEmpty)
            ? '${cached.name}-${cached.unit ?? ''}-${cached.store}'
            : cached.id!,
        name: cached.name,
        category: cached.category ?? 'Other',
        price: cached.price,
        store: cached.store,
      );
    }).toList();
  }
}
