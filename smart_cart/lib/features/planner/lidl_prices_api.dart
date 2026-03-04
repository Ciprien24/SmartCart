import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_cart/core/product.dart';

Future<List<Product>> fetchLidlProducts(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch Lidl prices (${response.statusCode})');
  }

  final decoded = jsonDecode(response.body);
  if (decoded is! Map<String, dynamic>) {
    throw Exception('Invalid Lidl response format');
  }

  final rawItems = decoded['items'];
  if (rawItems is! List) {
    throw Exception('Missing or invalid "items" array');
  }

  return rawItems
      .whereType<Map<String, dynamic>>()
      .map((item) {
        final name = (item['name'] ?? '').toString().trim();
        if (name.isEmpty) {
          throw Exception('Invalid product with empty name');
        }
        final unit = (item['unit'] ?? '').toString().trim();
        final category = (item['category'] ?? '').toString().trim();
        final priceRaw = item['price'];
        if (priceRaw is! num) {
          throw Exception('Invalid price for product "$name"');
        }

        return Product(
          id: unit.isEmpty ? name : '$name-$unit',
          name: name,
          category: category.isEmpty ? 'Other' : category,
          price: priceRaw.toDouble(),
          store: 'Lidl',
        );
      })
      .toList(growable: false);
}
