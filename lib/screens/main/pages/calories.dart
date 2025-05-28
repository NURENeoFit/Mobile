import 'package:flutter/material.dart';

import 'package:neofit_mobile/design/dimensions.dart';

class CaloriesPage extends StatefulWidget {
  const CaloriesPage({super.key});

  @override
  State<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  final _breakfastController = TextEditingController();
  final _lunchController = TextEditingController();
  final _dinnerController = TextEditingController();

  int _breakfastTotal = 0;
  int _lunchTotal = 0;
  int _dinnerTotal = 0;

  int get _totalCalories => _breakfastTotal + _lunchTotal + _dinnerTotal;

  void _addCalories(TextEditingController controller, void Function(int) update) {
    final value = int.tryParse(controller.text);

    if (value != null && value > 0) {
      if (_totalCalories + value > 30000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Total calories cannot exceed 30,000!'),
            backgroundColor: Color(0xFFB00010),
            duration: Duration(seconds: 3),
          ),
        );

        return;
      }

      update(value);
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Calculate Calories'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMealCard(context, 'Breakfast', _breakfastController, _breakfastTotal, (val) {
                setState(() => _breakfastTotal += val);
              }),
              _buildMealCard(context, 'Lunch', _lunchController, _lunchTotal, (val) {
                setState(() => _lunchTotal += val);
              }),
              _buildMealCard(context, 'Dinner', _dinnerController, _dinnerTotal, (val) {
                setState(() => _dinnerTotal += val);
              }),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: ColorScheme.of(context).primary.withValues(alpha: 0.1),
                  borderRadius: containerBorderRadius12,
                ),
                child: Text(
                  'Total calories: $_totalCalories',
                  style: const TextStyle(
                    fontSize: fontSizeHeader18,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, String title, TextEditingController controller, int total, void Function(int) update) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surface,
        borderRadius: containerBorderRadius12,
        boxShadow: [
          BoxShadow(color: ColorScheme.of(context).shadow, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: fontSizeHeader18,
                fontWeight: FontWeight.w600,
                color: ColorScheme.of(context).primary
              )
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 8,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Calories',
                    border: OutlineInputBorder(borderRadius: containerBorderRadius12),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () => _addCalories(controller, update),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorScheme.of(context).primary,
                    foregroundColor: ColorScheme.of(context).onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
                'Total: $total',
                style: const TextStyle(
                  fontSize: fontSizeGeneralText16,
                  fontWeight: FontWeight.w500
                )
            ),
          ),
        ],
      ),
    );
  }
}
