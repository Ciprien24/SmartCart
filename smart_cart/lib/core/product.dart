class Product {
  final String id;
  final String name;
  final String category;
  final double price; // price per unit
  final String store; // e.g. Lidl, Kaufland

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.store,
  });
}
