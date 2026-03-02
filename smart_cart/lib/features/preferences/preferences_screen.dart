import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cart/core/preferences.dart';
import 'package:smart_cart/features/planner/plan_generator.dart';
import 'package:smart_cart/features/shopping_list/shopping_list_screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
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
    'Auchan',
    'Mega Image',
    'Profi',
    'Penny',
    'Other',
  ];

  final List<String> _goalLabels = const [
    'Lose Weight',
    'Maintain Weight',
    'Gain Weight',
  ];

  double? _budget;
  String? _selectedSupermarket;
  String _selectedGoal = 'Maintain Weight';
  bool _showAdvancedPreferences = false;
  double? _fiberGoal;
  String? _dietaryRestriction;
  String? _activityLevel;
  String? _budgetError;
  String? _supermarketError;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _openBudgetSheet() async {
    final controller = TextEditingController(
      text: _budget == null ? '' : _budget!.toStringAsFixed(2),
    );

    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter budget',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(double.tryParse(controller.text));
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();

    if (!mounted || result == null) return;

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

  Future<void> _openFiberGoalSheet() async {
    final controller = TextEditingController(
      text: _fiberGoal == null ? '' : _fiberGoal!.toStringAsFixed(0),
    );

    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                'Fiber Goal',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter grams per day',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(double.tryParse(controller.text));
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();

    if (!mounted || result == null) return;
    setState(() => _fiberGoal = result);
  }

  Future<void> _openDietaryRestrictionPicker() async {
    const options = [
      'None',
      'Vegetarian',
      'Vegan',
      'Pescatarian',
      'Gluten-Free',
      'Lactose-Free',
    ];

    final result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Dietary Restriction'),
        actions: options
            .map(
              (option) => CupertinoActionSheetAction(
                onPressed: () => Navigator.of(context).pop(option),
                child: Text(option),
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
    setState(() => _dietaryRestriction = result);
  }

  Future<void> _openActivityLevelPicker() async {
    const options = [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ];

    final result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Activity Level'),
        actions: options
            .map(
              (option) => CupertinoActionSheetAction(
                onPressed: () => Navigator.of(context).pop(option),
                child: Text(option),
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
    setState(() => _activityLevel = result);
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

  void _continue() {
    setState(() {
      _budgetError = (_budget == null || _budget! <= 0)
          ? 'Please enter a valid budget'
          : null;
      _supermarketError = _selectedSupermarket == null
          ? 'Please choose a supermarket'
          : null;
    });

    if (_budgetError != null || _supermarketError != null) return;

    final preferences = Preferences(
      budgetWeekly: _budget!,
      supermarket: _selectedSupermarket!,
      goal: _goalToPreferenceValue(_selectedGoal),
    );
    final plan = PlanGenerator().generate(preferences);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ShoppingListScreen(plan: plan)),
    );
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
      height: 132,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Goal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: _textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              height: 100,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _segmentTrack,
                borderRadius: BorderRadius.circular(14),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final topRowLabels = _goalLabels
                      .take(3)
                      .toList(growable: false);
                  final bottomRowLabels = _goalLabels
                      .skip(3)
                      .toList(growable: false);
                  final segmentWidth = (constraints.maxWidth - 8) / 3;

                  Widget buildSegment(String label, {double? width}) {
                    final isSelected = _selectedGoal == label;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedGoal = label),
                      child: Container(
                        width: width,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? _textPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
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
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: topRowLabels
                            .map(
                              (label) => Expanded(child: buildSegment(label)),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 4),
                      if (bottomRowLabels.isNotEmpty)
                        Row(
                          children: bottomRowLabels
                              .take(3)
                              .map(
                                (label) => SizedBox(
                                  width: segmentWidth,
                                  child: buildSegment(label),
                                ),
                              )
                              .toList(growable: false),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
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
                    : '${_budget!.toStringAsFixed(2)} €',
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
              const SizedBox(height: 12),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1B2433), Color(0xFF0B1220)],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        _showAdvancedPreferences = !_showAdvancedPreferences;
                      });
                    },
                    child: Center(
                      child: Text(
                        _showAdvancedPreferences
                            ? 'Hide Advanced Preferences'
                            : 'Advanced Preferences',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_showAdvancedPreferences) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1, color: _divider),
                _buildStandardRow(
                  label: 'Fiber Goal',
                  value: _fiberGoal == null
                      ? 'Enter Fiber Goal'
                      : '${_fiberGoal!.toStringAsFixed(0)} g/day',
                  onTap: _openFiberGoalSheet,
                ),
                const Divider(height: 1, thickness: 1, color: _divider),
                _buildStandardRow(
                  label: 'Dietary Restriction',
                  value: _dietaryRestriction ?? 'Choose Restriction',
                  onTap: _openDietaryRestrictionPicker,
                ),
                const Divider(height: 1, thickness: 1, color: _divider),
                _buildStandardRow(
                  label: 'Activity Level',
                  value: _activityLevel ?? 'Choose Activity',
                  onTap: _openActivityLevelPicker,
                ),
                const Divider(height: 1, thickness: 1, color: _divider),
              ],
              const Spacer(),
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
                    onTap: _continue,
                    child: const Center(
                      child: Text(
                        'Continue',
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
