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
  final TextEditingController _budgetController = TextEditingController();

  final List<String> _supermarkets = const ['Lidl', 'Kaufland', 'Carrefour'];
  final List<String> _goals = const [
    'Lose weight',
    'Gain muscle',
    'Maintain',
  ];

  String _selectedSupermarket = 'Lidl';
  String _selectedGoal = 'Maintain';

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _generateWeeklyList() {
    final budgetText = _budgetController.text.trim();
    if (budgetText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a weekly budget.')),
      );
      return;
    }

    final budget = double.tryParse(budgetText);
    if (budget == null || budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid budget amount.')),
      );
      return;
    }

    final preferences = Preferences(
      budgetWeekly: budget,
      supermarket: _selectedSupermarket,
      goal: _selectedGoal,
    );

    final plan = PlanGenerator().generate(preferences);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShoppingListScreen(plan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Weekly budget (€)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSupermarket,
              decoration: const InputDecoration(
                labelText: 'Supermarket',
                border: OutlineInputBorder(),
              ),
              items: _supermarkets
                  .map(
                    (store) => DropdownMenuItem<String>(
                      value: store,
                      child: Text(store),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedSupermarket = value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGoal,
              decoration: const InputDecoration(
                labelText: 'Goal',
                border: OutlineInputBorder(),
              ),
              items: _goals
                  .map(
                    (goal) => DropdownMenuItem<String>(
                      value: goal,
                      child: Text(goal),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedGoal = value);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateWeeklyList,
                child: const Text('Generate Weekly List'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
