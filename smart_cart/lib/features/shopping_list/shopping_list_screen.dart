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
  static const Color _pageBackground = Color(0xFFF4F5F9);
  static const Color _headerBlue = Color(0xFF1800AD);
  static const Color _accentOrange = Color(0xFFFF751F);
  static const Color _textDark = Color(0xFF141414);
  static const Color _textMuted = Color(0xFF74788C);

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
        return 'lib/app/assets/kaufland.png';
      case 'Lidl':
        return 'lib/app/assets/lidl.png';
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
      grouped.putIfAbsent(item.product.category, () => <ShoppingItem>[]).add(item);
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

  Widget _buildHeader(double topInset) {
    return Container(
      height: 150 + topInset,
      padding: EdgeInsets.fromLTRB(24, topInset + 2, 24, 0),
      decoration: const BoxDecoration(color: _headerBlue),
      child: const Align(
        alignment: Alignment(0, -0.45),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image(
                image: AssetImage('lib/app/assets/logo_smart_cart.png'),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'SmartCart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String? logoPath) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: logoPath == null
                    ? const Icon(
                        CupertinoIcons.shopping_cart,
                        color: _textMuted,
                      )
                    : Image.asset(logoPath, fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.preferences.supermarket,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: _textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _pillInfo(
                  'Budget: ${widget.preferences.budgetWeekly.toStringAsFixed(0)} RON',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _pillInfo('Goal: ${_displayGoal(widget.preferences.goal)}'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pillInfo(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: _textMuted,
        ),
      ),
    );
  }

  Widget _buildItemCard(ShoppingItem item) {
    final subtitle = '${_unitFor(item)} x ${item.quantity}';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleChecked(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.checked ? _accentOrange : Colors.transparent,
                border: Border.all(
                  color: item.checked ? _accentOrange : const Color(0xFFBAC1CF),
                  width: 1.5,
                ),
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: item.checked ? 1 : 0,
                child: const Icon(
                  CupertinoIcons.check_mark,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _textDark.withValues(alpha: item.checked ? 0.55 : 1),
                    decoration: item.checked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.black,
                    decorationThickness: 2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatRon(item.lineTotal),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _decrease(item),
                      icon: const Icon(
                        CupertinoIcons.minus,
                        size: 14,
                        color: _accentOrange,
                      ),
                    ),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _textDark,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _increase(item),
                      icon: const Icon(
                        CupertinoIcons.plus,
                        size: 14,
                        color: _accentOrange,
                      ),
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
    final topInset = MediaQuery.of(context).padding.top;
    final grouped = _groupedItems();
    final logoPath = _storeLogoFor(widget.preferences.supermarket);

    return Scaffold(
      backgroundColor: _pageBackground,
      body: Stack(
        children: [
          Container(color: _pageBackground),
          _buildHeader(topInset),
          Positioned(
            top: 110 + topInset,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shopping List',
                      style: TextStyle(
                        color: _textDark,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _buildSummaryCard(logoPath),
                    const SizedBox(height: 18),
                    for (final entry in grouped.entries) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 10, top: 6),
                        child: Text(
                          _sectionTitle(entry.key),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _textDark,
                          ),
                        ),
                      ),
                      ...entry.value.map(_buildItemCard),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20 + MediaQuery.of(context).padding.bottom,
            child: Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: _accentOrange,
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.maybePop(context),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20 + MediaQuery.of(context).padding.bottom,
            child: Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _formatRon(_total),
                  style: const TextStyle(
                    color: _accentOrange,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
