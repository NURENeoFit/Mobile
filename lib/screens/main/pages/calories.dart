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

  int _breakfastInput = 0;
  int _lunchInput = 0;
  int _dinnerInput = 0;

  @override
  void initState() {
    super.initState();
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

  int get _addedTotal => _breakfastTotal + _lunchTotal + _dinnerTotal;
  int get _pendingTotal =>
      _breakfastInput + _lunchInput + _dinnerInput + _addedTotal;

  @override
  void dispose() {
    _breakfastController.dispose();
    _lunchController.dispose();
    _dinnerController.dispose();
    super.dispose();
  }

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
                input: _breakfastInput,
                total: _breakfastTotal,
                onAdd: () {
                  setState(() {
                    _breakfastTotal += _breakfastInput;
                    _breakfastController.clear();
                    _breakfastInput = 0;
                  });
                },
              ),
              _buildMealCard(
                title: 'Lunch',
                controller: _lunchController,
                input: _lunchInput,
                total: _lunchTotal,
                onAdd: () {
                  setState(() {
                    _lunchTotal += _lunchInput;
                    _lunchController.clear();
                    _lunchInput = 0;
                  });
                },
              ),
              _buildMealCard(
                title: 'Dinner',
                controller: _dinnerController,
                input: _dinnerInput,
                total: _dinnerTotal,
                onAdd: () {
                  setState(() {
                    _dinnerTotal += _dinnerInput;
                    _dinnerController.clear();
                    _dinnerInput = 0;
                  });
                },
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
                  'Total calories: $_addedTotal',
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
    required int input,
    required int total,
    required VoidCallback onAdd,
  }) {
    String? errorText;
    final isInvalidInput = controller.text.isNotEmpty && input <= 0;
    final willExceed = input > 0 && _pendingTotal > 30000;

    if (isInvalidInput) {
      errorText = 'Enter a valid number';
    } else if (willExceed) {
      errorText = 'Total calories cannot exceed 30,000!';
    }

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
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
              (input > 0 && _pendingTotal <= 30000) ? onAdd : null,
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
  }
}
