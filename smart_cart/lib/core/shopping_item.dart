import 'product.dart';

class ShoppingItem {
  final Product product;
  int quantity;
  bool checked;

  ShoppingItem({
    required this.product,
    this.quantity = 1,
    this.checked = false,
  });

  double get lineTotal => product.price * quantity;
}
