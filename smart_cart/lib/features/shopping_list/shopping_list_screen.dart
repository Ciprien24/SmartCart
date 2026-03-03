import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cart/core/preferences.dart';
import 'package:smart_cart/core/shopping_item.dart';
import 'package:smart_cart/core/weekly_plan.dart';

class ShoppingListScreen extends StatefulWidget {
  final WeeklyPlan plan;
  final Preferences preferences;

  const ShoppingListScreen({
    super.key,
    required this.plan,
    required this.preferences,
  });

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  static const Color _background = Color(0xFFFFFFFF);
  static const Color _divider = Color(0xFFE9EDF3);
  static const Color _textPrimary = Color(0xFF0B1220);
  static const Color _textSecondary = Color(0xFF8B93A1);
  static const Color _card = Color(0xFFF3F4F7);

  late List<ShoppingItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.plan.items;
  }

  String _formatRon(double value) => '${value.toStringAsFixed(2)} RON';

  String _displayGoal(String goal) {
    switch (goal) {
      case 'Lose weight':
        return 'Lose Weight';
      case 'Gain muscle':
        return 'Gain Weight';
      default:
        return 'Maintain Weight';
    }
  }

  String? _storeLogoFor(String store) {
    switch (store) {
      case 'Kaufland':
        return 'lib/app/assets/Kaufland_Logo.webp';
      case 'Lidl':
        return 'lib/app/assets/Lidl_Logo.webp';
      case 'Carrefour':
        return 'lib/app/assets/Carrefour_Logo.jpeg';
      case 'Mega Image':
        return 'lib/app/assets/Mega_Logo.png.avif';
      default:
        return null;
    }
  }

  String _unitFor(ShoppingItem item) {
    const unitMap = {
      'Chicken breast 1kg': '500g',
      'Greek yogurt 1kg': '250g',
      'Eggs 10 pcs': '10 pack',
      'Oats 1kg': '500g',
      'Rice 1kg': '1kg',
      'Pasta 1kg': '500g',
      'Bananas 1kg': '1kg',
      'Apples 1kg': '1kg',
      'Tomatoes 1kg': '1kg',
      'Frozen veggies 1kg': '500g',
      'Olive oil 500ml': '500ml',
      'Peanut butter 500g': '250g',
    };
    return unitMap[item.product.name] ?? '1 unit';
  }

  Map<String, List<ShoppingItem>> _groupedItems() {
    final grouped = <String, List<ShoppingItem>>{};
    for (final item in _items) {
      grouped
          .putIfAbsent(item.product.category, () => <ShoppingItem>[])
          .add(item);
    }
    final ordered = <String, List<ShoppingItem>>{};
    const order = ['Veggies', 'Fruits', 'Protein', 'Carbs', 'Fats'];
    for (final key in order) {
      if (grouped.containsKey(key)) {
        ordered[key] = grouped[key]!;
      }
    }
    for (final entry in grouped.entries) {
      if (!ordered.containsKey(entry.key)) {
        ordered[entry.key] = entry.value;
      }
    }
    return ordered;
  }

  String _sectionTitle(String category) {
    switch (category) {
      case 'Veggies':
      case 'Fruits':
        return 'Produce';
      case 'Carbs':
        return 'Pantry';
      case 'Fats':
        return 'Essentials';
      default:
        return category;
    }
  }

  double get _total => _items.fold(0.0, (sum, item) => sum + item.lineTotal);

  void _increase(ShoppingItem item) {
    setState(() => item.quantity += 1);
  }

  void _decrease(ShoppingItem item) {
    if (item.quantity <= 1) return;
    setState(() => item.quantity -= 1);
  }

  void _toggleChecked(ShoppingItem item) {
    setState(() => item.checked = !item.checked);
  }

  Widget _buildPremiumCheck(ShoppingItem item) {
    return GestureDetector(
      onTap: () => _toggleChecked(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: item.checked ? _textPrimary : Colors.transparent,
          border: Border.all(
            color: item.checked ? _textPrimary : const Color(0xFFAAB2BF),
            width: 1.5,
          ),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: item.checked ? 1 : 0,
          child: const Icon(
            CupertinoIcons.check_mark,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(ShoppingItem item) {
    final subtitle = '${_unitFor(item)} x ${item.quantity}';
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _divider, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: _buildPremiumCheck(item),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 40 / 2,
                    fontWeight: FontWeight.w500,
                    color: _textPrimary.withValues(
                      alpha: item.checked ? 0.65 : 1,
                    ),
                    decoration: item.checked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 34 / 2,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatRon(item.lineTotal),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _decrease(item),
                      icon: const Icon(CupertinoIcons.minus, size: 16),
                    ),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _increase(item),
                      icon: const Icon(CupertinoIcons.plus, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedItems();
    final logoPath = _storeLogoFor(widget.preferences.supermarket);
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          CupertinoIcons.back,
                          color: _textPrimary,
                          size: 30,
                        ),
                      ),
                      const Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.cart,
                              size: 28,
                              color: _textPrimary,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'SmartCart',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                                color: _textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: logoPath == null
                                  ? const Icon(
                                      CupertinoIcons.shopping_cart,
                                      color: _textSecondary,
                                    )
                                  : Image.asset(logoPath, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.preferences.supermarket,
                                style: const TextStyle(
                                  fontSize: 40 / 2,
                                  fontWeight: FontWeight.w500,
                                  color: _textPrimary,
                                ),
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.chevron_right,
                              size: 22,
                              color: _textSecondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9EBF0),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    'Budget: ${widget.preferences.budgetWeekly.toStringAsFixed(0)} RON',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: _textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9EBF0),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    'Goal: ${_displayGoal(widget.preferences.goal)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Color(0xFF4A5568),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 130),
                      children: [
                        for (final entry in grouped.entries) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 10),
                            child: Text(
                              _sectionTitle(entry.key),
                              style: const TextStyle(
                                fontSize: 42 / 2,
                                color: Color(0xFF5F636B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: _divider,
                          ),
                          ...entry.value.map(_buildItem),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 28,
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1B2433), Color(0xFF0B1220)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F0B1220),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 40 / 2,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatRon(_total),
                        style: const TextStyle(
                          fontSize: 48 / 2,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
