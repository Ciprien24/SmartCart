// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_cache_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProductCacheEntityCollection on Isar {
  IsarCollection<ProductCacheEntity> get productCacheEntitys =>
      this.collection();
}

const ProductCacheEntitySchema = CollectionSchema(
  name: r'ProductCacheEntity',
  id: 4643320272816442334,
  properties: {
    r'fetchedAt': PropertySchema(
      id: 0,
      name: r'fetchedAt',
      type: IsarType.string,
    ),
    r'products': PropertySchema(
      id: 1,
      name: r'products',
      type: IsarType.objectList,
      target: r'CachedProductEntity',
    ),
    r'savedAt': PropertySchema(
      id: 2,
      name: r'savedAt',
      type: IsarType.dateTime,
    ),
    r'storeKey': PropertySchema(
      id: 3,
      name: r'storeKey',
      type: IsarType.string,
    )
  },
  estimateSize: _productCacheEntityEstimateSize,
  serialize: _productCacheEntitySerialize,
  deserialize: _productCacheEntityDeserialize,
  deserializeProp: _productCacheEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'CachedProductEntity': CachedProductEntitySchema},
  getId: _productCacheEntityGetId,
  getLinks: _productCacheEntityGetLinks,
  attach: _productCacheEntityAttach,
  version: '3.1.0+1',
);

int _productCacheEntityEstimateSize(
  ProductCacheEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.fetchedAt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.products.length * 3;
  {
    final offsets = allOffsets[CachedProductEntity]!;
    for (var i = 0; i < object.products.length; i++) {
      final value = object.products[i];
      bytesCount +=
          CachedProductEntitySchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.storeKey.length * 3;
  return bytesCount;
}

void _productCacheEntitySerialize(
  ProductCacheEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.fetchedAt);
  writer.writeObjectList<CachedProductEntity>(
    offsets[1],
    allOffsets,
    CachedProductEntitySchema.serialize,
    object.products,
  );
  writer.writeDateTime(offsets[2], object.savedAt);
  writer.writeString(offsets[3], object.storeKey);
}

ProductCacheEntity _productCacheEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProductCacheEntity();
  object.fetchedAt = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.products = reader.readObjectList<CachedProductEntity>(
        offsets[1],
        CachedProductEntitySchema.deserialize,
        allOffsets,
        CachedProductEntity(),
      ) ??
      [];
  object.savedAt = reader.readDateTime(offsets[2]);
  object.storeKey = reader.readString(offsets[3]);
  return object;
}

P _productCacheEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readObjectList<CachedProductEntity>(
            offset,
            CachedProductEntitySchema.deserialize,
            allOffsets,
            CachedProductEntity(),
          ) ??
          []) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _productCacheEntityGetId(ProductCacheEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _productCacheEntityGetLinks(
    ProductCacheEntity object) {
  return [];
}

void _productCacheEntityAttach(
    IsarCollection<dynamic> col, Id id, ProductCacheEntity object) {
  object.id = id;
}

extension ProductCacheEntityQueryWhereSort
    on QueryBuilder<ProductCacheEntity, ProductCacheEntity, QWhere> {
  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProductCacheEntityQueryWhere
    on QueryBuilder<ProductCacheEntity, ProductCacheEntity, QWhereClause> {
  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProductCacheEntityQueryFilter
    on QueryBuilder<ProductCacheEntity, ProductCacheEntity, QFilterCondition> {
  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fetchedAt',
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fetchedAt',
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fetchedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fetchedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fetchedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fetchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fetchedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fetchedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fetchedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fetchedAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fetchedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      fetchedAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fetchedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      productsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'products',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      productsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'products',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      productsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'products',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      productsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'products',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      productsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'products',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      productsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'products',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      savedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      savedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'savedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      savedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'savedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      savedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'savedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'storeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'storeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'storeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'storeKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'storeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'storeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'storeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'storeKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'storeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      storeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'storeKey',
        value: '',
      ));
    });
  }
}

extension ProductCacheEntityQueryObject
    on QueryBuilder<ProductCacheEntity, ProductCacheEntity, QFilterCondition> {
  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterFilterCondition>
      productsElement(FilterQuery<CachedProductEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'products');
    });
  }
}

extension ProductCacheEntityQueryLinks
    on QueryBuilder<ProductCacheEntity, ProductCacheEntity, QFilterCondition> {}

extension ProductCacheEntityQuerySortBy
    on QueryBuilder<ProductCacheEntity, ProductCacheEntity, QSortBy> {
  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      sortByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      sortByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      sortBySavedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      sortBySavedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      sortByStoreKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeKey', Sort.asc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      sortByStoreKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeKey', Sort.desc);
    });
  }
}

extension ProductCacheEntityQuerySortThenBy
    on QueryBuilder<ProductCacheEntity, ProductCacheEntity, QSortThenBy> {
  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      thenByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      thenByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      thenBySavedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      thenBySavedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      thenByStoreKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeKey', Sort.asc);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QAfterSortBy>
      thenByStoreKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeKey', Sort.desc);
    });
  }
}

extension ProductCacheEntityQueryWhereDistinct
    on QueryBuilder<ProductCacheEntity, ProductCacheEntity, QDistinct> {
  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QDistinct>
      distinctByFetchedAt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fetchedAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QDistinct>
      distinctBySavedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savedAt');
    });
  }

  QueryBuilder<ProductCacheEntity, ProductCacheEntity, QDistinct>
      distinctByStoreKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'storeKey', caseSensitive: caseSensitive);
    });
  }
}

extension ProductCacheEntityQueryProperty
    on QueryBuilder<ProductCacheEntity, ProductCacheEntity, QQueryProperty> {
  QueryBuilder<ProductCacheEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProductCacheEntity, String?, QQueryOperations>
      fetchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fetchedAt');
    });
  }

  QueryBuilder<ProductCacheEntity, List<CachedProductEntity>, QQueryOperations>
      productsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'products');
    });
  }

  QueryBuilder<ProductCacheEntity, DateTime, QQueryOperations>
      savedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savedAt');
    });
  }

  QueryBuilder<ProductCacheEntity, String, QQueryOperations>
      storeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'storeKey');
    });
  }
}
