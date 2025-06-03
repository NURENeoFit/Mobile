import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/user_meal.dart';
import 'package:neofit_mobile/providers/user_meal_provider.dart';

class CaloriesPage extends ConsumerStatefulWidget {
  const CaloriesPage({super.key});

  @override
  ConsumerState<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends ConsumerState<CaloriesPage> {
  final _breakfastController = TextEditingController();
  final _lunchController = TextEditingController();
  final _dinnerController = TextEditingController();

  int _breakfastInput = 0;
  int _lunchInput = 0;
  int _dinnerInput = 0;

  @override
  void initState() {
    super.initState();
    // Trigger refresh when entering page
    Future.microtask(() {
      ref.read(userMealNotifierProvider.notifier).refresh();
    });

    _breakfastController.addListener(_updateInputs);
    _lunchController.addListener(_updateInputs);
    _dinnerController.addListener(_updateInputs);
  }

  void _updateInputs() {
    setState(() {
      _breakfastInput = int.tryParse(_breakfastController.text) ?? 0;
      _lunchInput = int.tryParse(_lunchController.text) ?? 0;
      _dinnerInput = int.tryParse(_dinnerController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    _breakfastController.dispose();
    _lunchController.dispose();
    _dinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mealsAsync = ref.watch(userMealNotifierProvider);

    return SafeArea(
      child: mealsAsync.when(
        data: (meals) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMealCard(
                title: 'Breakfast',
                controller: _breakfastController,
                input: _breakfastInput,
                total: (meals.firstWhere(
                      (meal) => meal.type == MealType.breakfast,
                  orElse: () => UserMeal(
                      type: MealType.breakfast,
                      calories: 0,
                      createdTime: DateTime.now()),
                ).calories) + _breakfastInput,
                onAdd: () {
                  ref.read(userMealNotifierProvider.notifier).updateMealCalories(MealType.breakfast, _breakfastInput);
                  _breakfastController.clear();
                },
              ),
              _buildMealCard(
                title: 'Lunch',
                controller: _lunchController,
                input: _lunchInput,
                total: (meals.firstWhere(
                      (meal) => meal.type == MealType.lunch,
                  orElse: () => UserMeal(
                      type: MealType.lunch,
                      calories: 0,
                      createdTime: DateTime.now()),
                ).calories) + _lunchInput,
                onAdd: () {
                  ref.read(userMealNotifierProvider.notifier).updateMealCalories(MealType.lunch, _lunchInput);
                  _lunchController.clear();
                },
              ),
              _buildMealCard(
                title: 'Dinner',
                controller: _dinnerController,
                input: _dinnerInput,
                total: (meals.firstWhere(
                      (meal) => meal.type == MealType.dinner,
                  orElse: () => UserMeal(
                      type: MealType.dinner,
                      calories: 0,
                      createdTime: DateTime.now()),
                ).calories) + _dinnerInput,
                onAdd: () {
                  ref.read(userMealNotifierProvider.notifier).updateMealCalories(MealType.dinner, _dinnerInput);
                  _dinnerController.clear();
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Total calories: ${meals.fold<int>(0, (sum, meal) => sum + meal.calories) + _breakfastInput + _lunchInput + _dinnerInput}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required TextEditingController controller,
    required int input,
    required int total,
    required VoidCallback onAdd,
  }) {
    String? errorText;
    final isInvalidInput = controller.text.isNotEmpty && input <= 0;
    final willExceed = input > 0 && (total + input) > 30000;

    if (isInvalidInput) {
      errorText = 'Enter a valid number';
    } else if (willExceed) {
      errorText = 'Total calories cannot exceed 30,000!';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: ColorScheme.of(context).shadow, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextTheme.of(context).titleMedium?.copyWith(
              color: ColorScheme.of(context).primary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Calories',
              errorText: errorText,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (input > 0 && (total + input) <= 30000) ? onAdd : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorScheme.of(context).primary,
                foregroundColor: ColorScheme.of(context).onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Add', style: TextTheme.of(context).labelMedium?.copyWith(
                  color: ColorScheme.of(context).onPrimary
              )),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total: $total',
              style: TextTheme.of(context).bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
