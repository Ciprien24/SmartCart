import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smart_cart/core/db/collections/shopping_item_entity.dart';
import 'package:smart_cart/core/db/product_cache_store.dart';
import 'package:smart_cart/core/db/shopping_list_repository.dart';
import 'package:smart_cart/core/preferences.dart';
import 'package:smart_cart/core/product.dart';
import 'package:smart_cart/core/shopping_item.dart';
import 'package:smart_cart/core/weekly_plan.dart';

class ShoppingListScreen extends StatefulWidget {
  final WeeklyPlan plan;
  final Preferences preferences;
  final int? savedListId;
  final String? fetchedAt;

  const ShoppingListScreen({
    super.key,
    required this.plan,
    required this.preferences,
    this.savedListId,
    this.fetchedAt,
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

  final ShoppingListRepository _repository = ShoppingListRepository();
  final ProductCacheStore _productCacheStore = ProductCacheStore();
  late List<ShoppingItem> _items;
  List<Product>? _cachedProducts;
  bool _isLoadingCachedProducts = false;
  Timer? _saveDebounce;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _items = List<ShoppingItem>.from(widget.plan.items);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    super.dispose();
  }

  String _formatRon(double value) => '${value.toStringAsFixed(2)} RON';

  String _formatUpdatedAt(String? fetchedAt) {
    if (fetchedAt == null || fetchedAt.isEmpty) {
      return 'Unknown';
    }

    final parsed = DateTime.tryParse(fetchedAt);
    if (parsed == null) return fetchedAt;
    final local = parsed.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = (local.year % 100).toString().padLeft(2, '0');
    return '$day/$month/$year';
  }

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
    _scheduleSave();
  }

  void _decrease(ShoppingItem item) {
    if (item.quantity <= 1) return;
    setState(() => item.quantity -= 1);
    _scheduleSave();
  }

  void _toggleChecked(ShoppingItem item) {
    setState(() => item.checked = !item.checked);
    _scheduleSave();
  }

  void _deleteItem(ShoppingItem item) {
    setState(() => _items.remove(item));
    _scheduleSave();
  }

  Future<void> _showReplaceSheet(ShoppingItem currentItem) async {
    setState(() {
      _isLoadingCachedProducts = true;
    });
    _cachedProducts ??= await _productCacheStore.getCachedProducts('Lidl');
    if (!mounted) return;
    setState(() {
      _isLoadingCachedProducts = false;
    });

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return _ReplaceItemBottomSheet(
          currentItem: currentItem,
          allProducts: _cachedProducts ?? const [],
          onSelect: (candidate) {
            _replaceItem(currentItem, candidate);
            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }

  void _replaceItem(ShoppingItem currentItem, Product replacement) {
    final index = _items.indexOf(currentItem);
    if (index < 0) return;

    final updatedItem = ShoppingItem(
      product: replacement,
      quantity: currentItem.quantity,
      checked: currentItem.checked,
    );

    setState(() {
      _items[index] = updatedItem;
    });
    _scheduleSave();

    final overBy = _total - widget.preferences.budgetWeekly;
    if (overBy > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Over budget by ${_formatRon(overBy)}')),
      );
    }
  }

  void _scheduleSave() {
    if (widget.savedListId == null) return;
    _saveDebounce?.cancel();
    setState(() {
      _isSaving = true;
    });
    _saveDebounce = Timer(const Duration(milliseconds: 500), () async {
      await _persistEdits();
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    });
  }

  Future<void> _persistEdits() async {
    final id = widget.savedListId;
    if (id == null) return;

    final entity = await _repository.getById(id);
    if (entity == null) return;

    entity.items = _items.map((item) {
      return ShoppingItemEntity()
        ..name = item.product.name
        ..price = item.product.price
        ..quantity = item.quantity
        ..checked = item.checked
        ..category = item.product.category;
    }).toList();

    await _repository.save(entity);
  }

  Future<void> _saveNow() async {
    _saveDebounce?.cancel();
    if (!_isSaving) return;
    await _persistEdits();
    if (!mounted) return;
    setState(() {
      _isSaving = false;
    });
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
                child: _pillInfo(
                  'Goal: ${_displayGoal(widget.preferences.goal)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF6E8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Prices Updated: ${_formatUpdatedAt(widget.fetchedAt)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B9E45),
              ),
            ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        key: ObjectKey(item),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.34,
          children: [
            CustomSlidableAction(
              onPressed: (_) => _showReplaceSheet(item),
              padding: EdgeInsets.zero,
              backgroundColor: const Color(0xFF2B6EEB),
              borderRadius: BorderRadius.zero,
              child: const Icon(
                CupertinoIcons.arrow_2_circlepath,
                color: Colors.white,
                size: 28,
              ),
            ),
            CustomSlidableAction(
              onPressed: (_) => _deleteItem(item),
              padding: EdgeInsets.zero,
              backgroundColor: const Color(0xFFD64545),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
              child: const Icon(
                CupertinoIcons.delete,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
        child: Container(
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
                      color: item.checked
                          ? _accentOrange
                          : const Color(0xFFBAC1CF),
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
                        color: _textDark.withValues(
                          alpha: item.checked ? 0.55 : 1,
                        ),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final grouped = _groupedItems();
    final logoPath = _storeLogoFor(widget.preferences.supermarket);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _saveNow();
        if (!mounted) return;
        Navigator.of(this.context).pop();
      },
      child: Scaffold(
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
                      if (_isLoadingCachedProducts) ...[
                        const SizedBox(height: 10),
                        const LinearProgressIndicator(
                          color: _accentOrange,
                          backgroundColor: Color(0xFFE9ECF3),
                          minHeight: 2,
                        ),
                      ],
                      const SizedBox(height: 18),
                      for (final entry in grouped.entries) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            bottom: 10,
                            top: 6,
                          ),
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
                    onTap: () async {
                      await _saveNow();
                      if (!mounted) return;
                      Navigator.of(this.context).maybePop();
                    },
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatRon(_total),
                      style: const TextStyle(
                        color: _accentOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (widget.savedListId != null) const SizedBox(height: 2),
                    if (widget.savedListId != null)
                      Text(
                        _isSaving ? 'Saving...' : 'Saved',
                        style: TextStyle(
                          color: _isSaving
                              ? const Color(0xFFF2B705)
                              : const Color(0xFF1B9E45),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReplaceItemBottomSheet extends StatefulWidget {
  const _ReplaceItemBottomSheet({
    required this.currentItem,
    required this.allProducts,
    required this.onSelect,
  });

  final ShoppingItem currentItem;
  final List<Product> allProducts;
  final ValueChanged<Product> onSelect;

  @override
  State<_ReplaceItemBottomSheet> createState() =>
      _ReplaceItemBottomSheetState();
}

class _ReplaceItemBottomSheetState extends State<_ReplaceItemBottomSheet> {
  static const Color _textDark = Color(0xFF141414);
  static const Color _textMuted = Color(0xFF74788C);
  static const Color _accentOrange = Color(0xFFFF751F);

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  bool _onlyCheaperOrEqual = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _candidates() {
    final currentProduct = widget.currentItem.product;
    final category = currentProduct.category.trim();

    final filtered = widget.allProducts.where((product) {
      if (product.store.toLowerCase() != 'lidl') return false;

      final sameCategory = category.isEmpty || product.category == category;
      if (!sameCategory) return false;

      final sameProduct =
          product.id == currentProduct.id ||
          product.name.toLowerCase() == currentProduct.name.toLowerCase();
      if (sameProduct) return false;

      if (_onlyCheaperOrEqual && product.price > currentProduct.price) {
        return false;
      }

      if (_searchText.trim().isNotEmpty &&
          !product.name.toLowerCase().contains(_searchText.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();

    filtered.sort((a, b) => a.price.compareTo(b.price));
    return filtered;
  }

  String _unitForProduct(Product product) {
    if (product.id.startsWith('${product.name}-')) {
      final unit = product.id.substring(product.name.length + 1);
      if (unit.isNotEmpty) return unit;
    }
    return 'unit';
  }

  @override
  Widget build(BuildContext context) {
    final results = _candidates();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Replace item',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchText = value),
              decoration: InputDecoration(
                hintText: 'Search products',
                hintStyle: const TextStyle(
                  color: _textMuted,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: const Icon(
                  CupertinoIcons.search,
                  color: _textMuted,
                ),
                filled: true,
                fillColor: const Color(0xFFF2F3F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SwitchListTile(
              value: _onlyCheaperOrEqual,
              onChanged: (value) => setState(() => _onlyCheaperOrEqual = value),
              title: const Text(
                'Only show items cheaper or equal',
                style: TextStyle(
                  color: _textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              activeThumbColor: _accentOrange,
              contentPadding: EdgeInsets.zero,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${results.length} options',
                style: const TextStyle(
                  color: _textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: results.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No results',
                          style: TextStyle(
                            color: _textMuted,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: results.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final product = results[index];
                        return Material(
                          color: const Color(0xFFF7F8FB),
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => widget.onSelect(product),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: _textDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          product.category,
                                          style: const TextStyle(
                                            color: _textMuted,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${product.price.toStringAsFixed(2)} RON / ${_unitForProduct(product)}',
                                    style: const TextStyle(
                                      color: _accentOrange,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
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
