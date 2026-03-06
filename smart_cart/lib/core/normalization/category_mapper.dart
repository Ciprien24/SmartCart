String mapRetailerCategoryToNormalized(String? retailerCategory, String name) {
  final category = _normalizeText(retailerCategory ?? '');
  final productName = _normalizeText(name);
  final text = '$category $productName';
  final tokens = _tokenize(text);

  if (_isNonFood(text, tokens)) return 'other';

  if (_containsAnyToken(tokens, const [
    'chips',
    'snack',
    'biscuite',
    'biscuit',
    'biscuiti',
    'cookie',
    'cookies',
    'ciocolata',
    'chocolate',
    'napolitane',
    'candy',
    'praline',
    'covrigei',
    'sticks',
  ])) {
    return 'snack';
  }

  if (_containsAnyToken(tokens, const [
    'cola',
    'suc',
    'juice',
    'apa',
    'water',
    'ceai',
    'tea',
    'cafea',
    'coffee',
    'limonada',
    'energizant',
    'energy',
  ])) {
    return 'drink';
  }

  if (_containsAnyToken(tokens, const [
    'pui',
    'chicken',
    'curcan',
    'turkey',
    'porc',
    'pork',
    'beef',
    'somon',
    'salmon',
    'ton',
    'tuna',
    'peste',
    'fish',
  ]) ||
      ((_containsAnyToken(tokens, const ['oua', 'egg', 'eggs'])) &&
          !_containsAnyToken(tokens, const [
            'surpriza',
            'kinder',
            'ciocolata',
            'chocolate',
            'biscuit',
            'cookie',
            'croissant',
          ]))) {
    if (!_containsAnyToken(tokens, const [
      'condiment',
      'supa',
      'croissant',
      'biscuit',
      'cookie',
      'pisici',
      'caini',
      'pet',
    ])) {
      return 'protein';
    }
  }

  if (_containsAnyToken(tokens, const [
    'iaurt',
    'yogurt',
    'lapte',
    'milk',
    'kefir',
    'branza',
    'cascaval',
    'telemea',
    'mozzarella',
    'smantana',
    'cheese',
    'skyr',
  ])) {
    return 'dairy';
  }

  if (_containsAnyToken(tokens, const [
    'orez',
    'rice',
    'paste',
    'pasta',
    'paine',
    'bread',
    'ovaz',
    'oats',
    'faina',
    'cereale',
    'musli',
    'granola',
    'gris',
  ])) {
    return 'carb';
  }

  if (_containsAnyPhrase(text, const ['unt arahide', 'peanut butter']) ||
      _containsAnyToken(tokens, const [
        'ulei',
        'olive',
        'masline',
        'nuci',
        'nuts',
        'migdale',
        'seminte',
        'seeds',
        'avocado',
        'margarina',
      ])) {
    return 'fat';
  }

  if (_containsAnyToken(tokens, const [
    'mar',
    'mere',
    'banana',
    'banane',
    'portocala',
    'portocale',
    'lamaie',
    'lamai',
    'afine',
    'zmeura',
    'capsuni',
    'struguri',
    'kiwi',
    'mango',
    'ananas',
    'para',
    'pere',
    'pepene',
    'caise',
    'piersici',
    'prune',
    'grapefruit',
    'fructe',
  ])) {
    return 'fruit';
  }

  if (_containsAnyToken(tokens, const [
    'rosii',
    'tomate',
    'tomato',
    'castraveti',
    'castravete',
    'cucumber',
    'ceapa',
    'morcov',
    'broccoli',
    'spanac',
    'spinach',
    'salata',
    'ardei',
    'pepper',
    'cartof',
    'dovlecel',
    'vinete',
    'varza',
    'conopida',
    'ciuperci',
    'usturoi',
    'legume',
  ])) {
    return 'vegetable';
  }

  if (_containsAnyPhrase(category, const [
    'lactate',
    'branzeturi',
    'mezeluri',
    'peste',
    'carne',
    'bauturi',
    'dulciuri',
    'legume',
    'fructe',
    'panificatie',
    'cereale',
  ])) {
    if (_containsAnyPhrase(category, const ['lactate', 'branzeturi'])) return 'dairy';
    if (_containsAnyPhrase(category, const ['carne', 'mezeluri', 'peste'])) {
      return 'protein';
    }
    if (_containsAnyPhrase(category, const ['bauturi'])) return 'drink';
    if (_containsAnyPhrase(category, const ['dulciuri'])) return 'snack';
    if (_containsAnyPhrase(category, const ['fructe'])) return 'fruit';
    if (_containsAnyPhrase(category, const ['legume'])) return 'vegetable';
    if (_containsAnyPhrase(category, const ['panificatie', 'cereale'])) {
      return 'carb';
    }
  }

  return 'other';
}

bool _isNonFood(String text, Set<String> tokens) {
  if (_containsAnyPhrase(text, const [
    'pet food',
    'hrana caini',
    'hrana pisici',
    'detergent',
    'sampon',
    'deodorant',
    'periuta',
    'servetele',
    'burete',
    'scutece',
    'toothpaste',
    'cosmetic',
    'baby',
    'pet',
  ])) {
    return true;
  }
  return _containsAnyToken(tokens, const [
    'cosmetic',
    'detergent',
    'sampon',
    'deodorant',
    'periuta',
    'servetele',
    'scutece',
    'toys',
    'jucarie',
    'pisici',
    'caini',
    'dog',
    'cat',
    'pet',
    'litter',
    'nisip',
  ]);
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
