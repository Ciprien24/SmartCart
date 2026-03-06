import 'package:isar/isar.dart';

part 'normalized_product_entity.g.dart';

@collection
class NormalizedProductEntity {
  Id id = Isar.autoIncrement;

  String productId = '';
  String name = '';
  String store = '';
  double price = 0;
  String? unit;
  String? retailerCategory;
  String normalizedCategory = 'other';
  List<String> tags = [];
  DateTime updatedAt = DateTime.now();
}
