import 'package:flutter/foundation.dart';
import 'package:smart_cart/core/db/normalized_product_mapper.dart';
import 'package:smart_cart/core/db/normalized_product_repository.dart';
import 'package:smart_cart/core/normalization/normalized_product.dart';

class CandidateBuilder {
  CandidateBuilder({NormalizedProductRepository? repository})
    : _repository = repository ?? NormalizedProductRepository();

  final NormalizedProductRepository _repository;

  Future<List<NormalizedProduct>> buildCandidates({
    required String store,
    required double budget,
    String? goal,
    bool debug = false,
  }) async {
    final entities = await _repository.getAllForStore(store);
    final all = entities.map(NormalizedProductMapper.toDomain).toList();
    if (all.isEmpty) {
      return const [];
    }

    final normalizedGoal = (goal ?? '').toLowerCase();
    final scored = all
        .map((product) => _ScoredCandidate(product, _score(product, budget, normalizedGoal)))
        .toList()
      ..sort(_compareScored);

    final byCategory = <String, List<_ScoredCandidate>>{};
    for (final candidate in scored) {
      byCategory.putIfAbsent(candidate.product.normalizedCategory, () => []).add(candidate);
    }

    const preferredOrder = ['protein', 'vegetable', 'fruit', 'carb', 'dairy', 'fat'];
    const fallbackOrder = ['snack', 'drink', 'other'];
    const preferredCaps = {
      'protein': 22,
      'vegetable': 18,
      'fruit': 14,
      'carb': 16,
      'dairy': 12,
      'fat': 10,
    };
    const fallbackCaps = {'snack': 8, 'drink': 6, 'other': 6};

    final selected = <NormalizedProduct>[];
    final selectedIds = <String>{};

    for (final category in preferredOrder) {
      final categoryItems = byCategory[category] ?? const [];
      final cap = preferredCaps[category] ?? 0;
      for (var i = 0; i < categoryItems.length && i < cap; i++) {
        final product = categoryItems[i].product;
        if (selectedIds.add(product.id)) {
          selected.add(product);
        }
      }
    }

    const minTarget = 60;
    const maxTarget = 120;
    if (selected.length < minTarget) {
      for (final category in fallbackOrder) {
        final categoryItems = byCategory[category] ?? const [];
        final cap = fallbackCaps[category] ?? 0;
        for (var i = 0; i < categoryItems.length && i < cap; i++) {
          final product = categoryItems[i].product;
          if (selectedIds.add(product.id)) {
            selected.add(product);
            if (selected.length >= minTarget) {
              break;
            }
          }
        }
        if (selected.length >= minTarget) {
          break;
        }
      }
    }

    final limited = selected.take(maxTarget).toList(growable: false);
    if (debug) {
      debugPrintCandidateSummary(limited);
    }
    return limited;
  }

  double _score(NormalizedProduct product, double budget, String goal) {
    var score = _categoryBaseScore(product.normalizedCategory);
    final tags = product.tags.map((tag) => tag.toLowerCase()).toSet();

    if (tags.contains('high_protein')) score += 2.0;
    if (tags.contains('high_fiber')) score += 1.3;
    if (tags.contains('healthy_fat')) score += 1.2;
    if (tags.contains('fresh')) score += 1.1;
    if (tags.contains('processed')) score -= 1.8;

    final referenceItemBudget = (budget / 20).clamp(0.5, 1000.0);
    final priceRatio = product.price / referenceItemBudget;
    if (priceRatio <= 1) {
      score += (1 - priceRatio) * 1.5;
    } else {
      score -= (priceRatio - 1).clamp(0, 2.0);
    }

    if (goal.contains('lose')) {
      if (product.normalizedCategory == 'vegetable' || product.normalizedCategory == 'fruit') {
        score += 0.6;
      }
      if (product.normalizedCategory == 'snack' || product.normalizedCategory == 'drink') {
        score -= 0.8;
      }
      if (tags.contains('processed')) score -= 0.4;
    } else if (goal.contains('gain')) {
      if (product.normalizedCategory == 'protein') score += 1.0;
      if (product.normalizedCategory == 'carb') score += 0.4;
      if (tags.contains('high_protein')) score += 0.8;
    } else {
      if (product.normalizedCategory == 'protein' || product.normalizedCategory == 'vegetable') {
        score += 0.3;
      }
    }

    return score;
  }

  double _categoryBaseScore(String category) {
    switch (category) {
      case 'protein':
        return 4.0;
      case 'vegetable':
        return 3.8;
      case 'fruit':
        return 3.6;
      case 'carb':
        return 3.4;
      case 'dairy':
        return 3.0;
      case 'fat':
        return 2.7;
      case 'snack':
        return 1.3;
      case 'drink':
        return 1.1;
      default:
        return 0.8;
    }
  }

  int _compareScored(_ScoredCandidate a, _ScoredCandidate b) {
    final scoreDiff = b.score.compareTo(a.score);
    if (scoreDiff != 0) return scoreDiff;

    final priceDiff = a.product.price.compareTo(b.product.price);
    if (priceDiff != 0) return priceDiff;

    return a.product.name.toLowerCase().compareTo(b.product.name.toLowerCase());
  }
}

void debugPrintCandidateSummary(List<NormalizedProduct> candidates) {
  final categoryCounts = <String, int>{};
  for (final product in candidates) {
    categoryCounts[product.normalizedCategory] =
        (categoryCounts[product.normalizedCategory] ?? 0) + 1;
  }
  final sortedCategories = categoryCounts.keys.toList()..sort();

  final lines = <String>[
    '[Candidates] total=${candidates.length}',
    '[Candidates] byCategory:',
    ...sortedCategories.map((key) => '  - $key: ${categoryCounts[key]}'),
    '[Candidates] first20:',
    ...candidates.take(20).map(
      (p) =>
          '  - ${p.name} | ${p.normalizedCategory} | ${p.price.toStringAsFixed(2)} | tags=${p.tags.join(",")}',
    ),
  ];

  for (final line in lines) {
    debugPrint(line);
  }
}

class _ScoredCandidate {
  const _ScoredCandidate(this.product, this.score);

  final NormalizedProduct product;
  final double score;
}
