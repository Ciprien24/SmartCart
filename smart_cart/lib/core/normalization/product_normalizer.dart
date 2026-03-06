import 'package:smart_cart/core/normalization/category_mapper.dart';
import 'package:smart_cart/core/normalization/normalized_product.dart';
import 'package:smart_cart/core/normalization/product_tagger.dart';
import 'package:smart_cart/core/product.dart';

NormalizedProduct normalizeProduct(Product product) {
  final normalizedCategory = mapRetailerCategoryToNormalized(
    product.category,
    product.name,
  );

  final unit = _extractUnit(product);
  final tags = buildProductTags(
    name: product.name,
    retailerCategory: product.category,
    normalizedCategory: normalizedCategory,
  );

  return NormalizedProduct(
    id: product.id,
    name: product.name,
    store: product.store,
    price: product.price,
    unit: unit,
    retailerCategory: product.category,
    normalizedCategory: normalizedCategory,
    tags: tags,
  );
}

List<NormalizedProduct> normalizeProducts(List<Product> products) {
  return products.map(normalizeProduct).toList(growable: false);
}

String? _extractUnit(Product product) {
  final prefix = '${product.name}-';
  if (product.id.startsWith(prefix)) {
    final unit = product.id.substring(prefix.length).trim();
    return unit.isEmpty ? null : unit;
  }
  return null;
}
