import 'package:flutter/material.dart';
import 'package:smart_cart/core/shopping_item.dart';
import 'package:smart_cart/core/weekly_plan.dart';

class ShoppingListScreen extends StatefulWidget {
  final WeeklyPlan plan;

  const ShoppingListScreen({super.key, required this.plan});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  late WeeklyPlan _plan;

  @override
  void initState() {
    super.initState();
    _plan = widget.plan;
  }

  void _increaseQuantity(ShoppingItem item) {
    setState(() {
      item.quantity += 1;
    });
  }

  void _decreaseQuantity(ShoppingItem item) {
    if (item.quantity <= 1) return;
    setState(() {
      item.quantity -= 1;
    });
  }

  void _toggleChecked(ShoppingItem item, bool? checked) {
    setState(() {
      item.checked = checked ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Shopping List')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: ${_plan.totalEstimated.toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _plan.items.length,
                itemBuilder: (context, index) {
                  final item = _plan.items[index];
                  return ListTile(
                    leading: Checkbox(
                      value: item.checked,
                      onChanged: (value) => _toggleChecked(item, value),
                    ),
                    title: Text(item.product.name),
                    subtitle: Text(
                      'Unit: ${item.product.price.toStringAsFixed(2)} € • '
                      'Line: ${item.lineTotal.toStringAsFixed(2)} €',
                    ),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _decreaseQuantity(item),
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            onPressed: () => _increaseQuantity(item),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
