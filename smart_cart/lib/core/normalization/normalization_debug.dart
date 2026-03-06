import 'package:flutter/foundation.dart';

import 'package:smart_cart/core/normalization/product_normalizer.dart';
import 'package:smart_cart/core/product.dart';

void debugPrintNormalizationSummary(List<Product> products) {
  final normalized = normalizeProducts(products);
  final categoryCounts = <String, int>{};
  final tagCounts = <String, int>{};

  for (final item in normalized) {
    categoryCounts[item.normalizedCategory] =
        (categoryCounts[item.normalizedCategory] ?? 0) + 1;
    for (final tag in item.tags) {
      tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
    }
  }

  final sortedCategories = categoryCounts.keys.toList()..sort();
  final sortedTags = tagCounts.keys.toList()
    ..sort((a, b) => (tagCounts[b] ?? 0).compareTo(tagCounts[a] ?? 0));
  final preview = normalized.take(10).toList();
  final topOther = normalized
      .where((item) => item.normalizedCategory == 'other')
      .take(10)
      .toList();

  final lines = <String>[
    '[Normalization] total=${normalized.length}',
    '[Normalization] byCategory:',
    ...sortedCategories.map((key) => '  - $key: ${categoryCounts[key]}'),
    '[Normalization] topTags:',
    ...sortedTags.take(15).map((key) => '  - $key: ${tagCounts[key]}'),
    '[Normalization] topOther:',
    ...topOther.map((p) => '  - ${p.name} | ${p.retailerCategory ?? '-'}'),
    '[Normalization] first10:',
    ...preview.map(
      (p) =>
          '  - ${p.name} | ${p.normalizedCategory} | ${p.price.toStringAsFixed(2)} | tags=${p.tags.join(",")}',
    ),
  ];

  for (final line in lines) {
    debugPrint(line);
  }
}
