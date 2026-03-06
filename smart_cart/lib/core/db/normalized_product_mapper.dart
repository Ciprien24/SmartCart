import 'package:smart_cart/core/db/collections/normalized_product_entity.dart';
import 'package:smart_cart/core/normalization/normalized_product.dart';

class NormalizedProductMapper {
  NormalizedProductMapper._();

  static NormalizedProductEntity toEntity(
    NormalizedProduct product, {
    DateTime? updatedAt,
  }) {
    return NormalizedProductEntity()
      ..productId = product.id
      ..name = product.name
      ..store = product.store
      ..price = product.price
      ..unit = product.unit
      ..retailerCategory = product.retailerCategory
      ..normalizedCategory = product.normalizedCategory
      ..tags = List<String>.from(product.tags)
      ..updatedAt = updatedAt ?? DateTime.now();
  }

  static NormalizedProduct toDomain(NormalizedProductEntity entity) {
    return NormalizedProduct(
      id: entity.productId,
      name: entity.name,
      store: entity.store,
      price: entity.price,
      unit: entity.unit,
      retailerCategory: entity.retailerCategory,
      normalizedCategory: entity.normalizedCategory,
      tags: List<String>.from(entity.tags),
    );
  }
}
