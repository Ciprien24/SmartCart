class NormalizedProduct {
  final String id;
  final String name;
  final String store;
  final double price;
  final String? unit;
  final String? retailerCategory;
  final String normalizedCategory;
  final List<String> tags;

  const NormalizedProduct({
    required this.id,
    required this.name,
    required this.store,
    required this.price,
    required this.unit,
    required this.retailerCategory,
    required this.normalizedCategory,
    required this.tags,
  });
}
