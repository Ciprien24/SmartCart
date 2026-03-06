List<String> buildProductTags({
  required String name,
  String? retailerCategory,
  required String normalizedCategory,
}) {
  final text = _normalizeText('$name ${retailerCategory ?? ''}');
  final tokens = _tokenize(text);
  final tags = <String>{};
  final isNonFood = _containsAnyToken(tokens, const [
    'pisici',
    'caini',
    'pet',
    'dog',
    'cat',
    'detergent',
    'sampon',
  ]);
  final looksLikeSnack = _containsAnyToken(tokens, const [
    'chips',
    'snack',
    'biscuit',
    'biscuite',
    'cookie',
    'cookies',
    'ciocolata',
    'chocolate',
    'surpriza',
    'kinder',
    'praline',
    'napolitane',
  ]);

  if (!isNonFood &&
      !looksLikeSnack &&
      (_containsAnyToken(tokens, const [
        'pui',
        'chicken',
        'curcan',
        'turkey',
        'ton',
        'tuna',
        'somon',
        'salmon',
        'oua',
        'egg',
        'eggs',
        'skyr',
      ]) ||
          _containsAnyPhrase(text, const ['greek yogurt', 'iaurt grecesc']))) {
    tags.add('high_protein');
  }

  if (!isNonFood &&
      !looksLikeSnack &&
      (_containsAnyPhrase(text, const ['piept pui', 'chicken breast']) ||
          _containsAnyToken(tokens, const ['curcan', 'turkey', 'ton', 'tuna'])) &&
      !_containsAnyToken(tokens, const ['mezel', 'salam', 'parizer'])) {
    tags.add('lean_protein');
  }

  if (_containsAnyToken(tokens, const [
    'ovaz',
    'oats',
    'fasole',
    'naut',
    'linte',
    'lentils',
    'broccoli',
    'cereale',
    'integrale',
  ])) {
    tags.add('high_fiber');
  }

  if (_containsAnyPhrase(text, const ['unt arahide', 'peanut butter']) ||
      _containsAnyToken(tokens, const [
        'avocado',
        'nuci',
        'nuts',
        'migdale',
        'seminte',
        'seeds',
        'olive',
        'masline',
      ])) {
    tags.add('healthy_fat');
  }

  if (normalizedCategory == 'snack' ||
      _containsAnyToken(tokens, const [
        'chips',
        'cola',
        'salam',
        'mezel',
        'parizer',
        'biscuit',
        'biscuite',
        'cookies',
        'ciocolata',
        'instant',
        'sos',
      ])) {
    tags.add('processed');
  }

  if ((normalizedCategory == 'vegetable' || normalizedCategory == 'fruit') &&
      !tags.contains('processed')) {
    tags.add('fresh');
  }

  if (normalizedCategory == 'dairy') tags.add('dairy');
  if (normalizedCategory == 'snack') tags.add('snack');
  if (normalizedCategory == 'drink') tags.add('drink');

  return tags.toList()..sort();
}

String _normalizeText(String input) {
  return input
      .toLowerCase()
      .replaceAll('ă', 'a')
      .replaceAll('â', 'a')
      .replaceAll('î', 'i')
      .replaceAll('ș', 's')
      .replaceAll('ş', 's')
      .replaceAll('ț', 't')
      .replaceAll('ţ', 't');
}

Set<String> _tokenize(String text) {
  return text
      .split(RegExp(r'[^a-z0-9]+'))
      .where((part) => part.isNotEmpty)
      .toSet();
}

bool _containsAnyToken(Set<String> tokens, List<String> keywords) {
  for (final keyword in keywords) {
    if (tokens.contains(keyword)) return true;
  }
  return false;
}

bool _containsAnyPhrase(String text, List<String> keywords) {
  for (final keyword in keywords) {
    if (text.contains(keyword)) return true;
  }
  return false;
}
