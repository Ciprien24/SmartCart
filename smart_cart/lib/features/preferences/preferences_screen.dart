import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cart/core/preferences.dart';
import 'package:smart_cart/features/carts/carts_screen.dart';
import 'package:smart_cart/features/planner/lidl_prices_api.dart';
import 'package:smart_cart/features/planner/plan_generator.dart';
import 'package:smart_cart/features/shopping_list/shopping_list_screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  static const String _lidlUrl =
      'https://raw.githubusercontent.com/Ciprien24/SmartCart_Backend/refs/heads/main/data/lidl/latest.json';
  static const Color _background = Color(0xFFFFFFFF);
  static const Color _divider = Color(0xFFE9EDF3);
  static const Color _textPrimary = Color(0xFF0B1220);
  static const Color _textSecondary = Color(0xFF8B93A1);
  static const Color _chevron = Color(0xFFAAB2BF);
  static const Color _segmentTrack = Color(0xFFF1F3F6);
  static const Color _segmentTextUnselected = Color(0xFF6E7685);
  static const Color _error = Color(0xFFD64545);

  final List<String> _supermarkets = const [
    'Kaufland',
    'Lidl',
    'Carrefour',
    'Mega Image',
  ];

  final List<String> _goalLabels = const [
    'Lose Weight',
    'Maintain Weight',
    'Gain Weight',
  ];

  double? _budget;
  String? _selectedSupermarket;
  String _selectedGoal = 'Maintain Weight';
  String? _budgetError;
  String? _supermarketError;
  String? _generateError;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _openBudgetSheet() async {
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        double selectedBudget = _budget ?? 200;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Budget',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${selectedBudget.toStringAsFixed(0)} RON',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  Slider(
                    min: 50,
                    max: 1000,
                    divisions: 190,
                    value: selectedBudget.clamp(50, 1000),
                    activeColor: _textPrimary,
                    onChanged: (value) {
                      setModalState(() {
                        selectedBudget = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(selectedBudget);
                      },
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (!mounted) return;

    if (result == null) {
      setState(() {
        _budgetError = 'Please enter a valid budget';
      });
      return;
    }

    setState(() {
      _budget = result;
      _budgetError = null;
    });
  }

  Future<void> _openSupermarketPicker() async {
    final result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Preferred Supermarket'),
        actions: _supermarkets
            .map(
              (market) => CupertinoActionSheetAction(
                onPressed: () => Navigator.of(context).pop(market),
                child: Text(market),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          isDefaultAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );

    if (!mounted || result == null) return;
    setState(() {
      _selectedSupermarket = result;
      _supermarketError = null;
    });
  }

  String _goalToPreferenceValue(String label) {
    switch (label) {
      case 'Lose Weight':
        return 'Lose weight';
      case 'Gain Weight':
        return 'Gain muscle';
      case 'Maintain Weight':
      default:
        return 'Maintain';
    }
  }

  Future<void> _continue() async {
    setState(() {
      _budgetError = (_budget == null || _budget! <= 0)
          ? 'Please enter a valid budget'
          : null;
      _supermarketError = _selectedSupermarket == null
          ? 'Please choose a supermarket'
          : null;
      _generateError = null;
    });

    if (_budgetError != null || _supermarketError != null) return;

    final preferences = Preferences(
      budgetWeekly: _budget!,
      supermarket: _selectedSupermarket!,
      goal: _goalToPreferenceValue(_selectedGoal),
    );

    setState(() {
      _isLoading = true;
    });

    try {
      final products = await fetchLidlProducts(_lidlUrl);
      if (!mounted) return;
      final plan = PlanGenerator().generateFromProducts(preferences, products);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ShoppingListScreen(plan: plan, preferences: preferences),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      final message = error.toString();
      setState(() {
        _generateError = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to generate list: $message')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildStandardRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 64,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: _textPrimary,
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: _textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(CupertinoIcons.chevron_right, size: 18, color: _chevron),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalRow() {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          const Text(
            'Goal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: _textPrimary,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 38,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _segmentTrack,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: _goalLabels
                    .map((label) {
                      final isSelected = _selectedGoal == label;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedGoal = label),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _textPrimary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : _segmentTextUnselected,
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: _textPrimary,
    );
    const logoSize = 28.0;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                          return;
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CartsScreen()),
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.back,
                        size: 30,
                        color: _textPrimary,
                      ),
                    ),
                  ),
                  const Text('SmartCart', style: titleStyle),
                  Transform.translate(
                    offset: const Offset(-112, 0),
                    child: const Icon(
                      CupertinoIcons.cart,
                      size: logoSize,
                      color: _textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Set Your Preferences',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: _textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Divider(height: 1, thickness: 1, color: _divider),
              _buildStandardRow(
                label: 'Budget',
                value: _budget == null
                    ? 'Enter Budget'
                    : '${_budget!.toStringAsFixed(0)} RON',
                onTap: _openBudgetSheet,
              ),
              const Divider(height: 1, thickness: 1, color: _divider),
              if (_budgetError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _budgetError!,
                    style: const TextStyle(
                      color: _error,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              _buildStandardRow(
                label: 'Preferred Supermarket',
                value: _selectedSupermarket ?? 'Choose Supermarket',
                onTap: _openSupermarketPicker,
              ),
              const Divider(height: 1, thickness: 1, color: _divider),
              if (_supermarketError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _supermarketError!,
                    style: const TextStyle(
                      color: _error,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              _buildGoalRow(),
              const Divider(height: 1, thickness: 1, color: _divider),
              const Spacer(),
              if (_generateError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _generateError!,
                    style: const TextStyle(
                      color: _error,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              Container(
                height: 72,
                margin: const EdgeInsets.only(bottom: 28),
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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _isLoading ? null : _continue,
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Generate Weekly List',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
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
