import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      appBar: AppBar(
        title: const Text('Calculate Calories'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMealCard(
                title: 'Breakfast',
                controller: _breakfastController,
                total: _breakfastTotal,
                update: (val) => setState(() => _breakfastTotal += val),
              ),
              _buildMealCard(
                title: 'Lunch',
                controller: _lunchController,
                total: _lunchTotal,
                update: (val) => setState(() => _lunchTotal += val),
              ),
              _buildMealCard(
                title: 'Dinner',
                controller: _dinnerController,
                total: _dinnerTotal,
                update: (val) => setState(() => _dinnerTotal += val),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Total calories: $_totalCalories',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required TextEditingController controller,
    required int total,
    required void Function(int) update,
  }) {
    String? errorText;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
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
                onChanged: (value) {
                  final input = int.tryParse(value);
                  setLocalState(() {
                    if (input == null || input <= 0) {
                      errorText = 'Enter a valid number';
                    } else if (_totalCalories + input > 30000) {
                      errorText = 'Total calories cannot exceed 30,000!';
                    } else {
                      errorText = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final input = int.tryParse(controller.text);
                    if (input != null &&
                        input > 0 &&
                        _totalCalories + input <= 30000) {
                      update(input);
                      controller.clear();
                      setLocalState(() {
                        errorText = null;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Add'),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total: $total',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
