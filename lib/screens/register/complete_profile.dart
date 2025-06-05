import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/models/user/program_goal.dart';
import 'package:neofit_mobile/models/user/personal_user_data.dart';
import 'package:neofit_mobile/models/user_target_calculation.dart';
import 'package:neofit_mobile/providers/user/user_profile_provider.dart';
import 'package:neofit_mobile/providers/user/user_target_calculation_provider.dart';

class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  ConsumerState<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  Gender? _selectedGender;
  ActivityLevel? _selectedActivityLevel;
  GoalType? _selectedGoalType;
  DateTime? _selectedDateOfBirth;

  String? _targetWeightErrorText;

  bool get _shouldEnterTargetWeight =>
      _selectedGoalType == GoalType.weightLoss || _selectedGoalType == GoalType.muscleGain;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  int? _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return null;
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _onSave() async {
    final age = _calculateAge(_selectedDateOfBirth);
    final currentWeight = double.tryParse(_weightController.text) ?? 0.0;
    final targetWeight = _shouldEnterTargetWeight
        ? double.tryParse(_targetWeightController.text) ?? currentWeight
        : currentWeight;

    _targetWeightErrorText = null;

    if (_shouldEnterTargetWeight) {
      if (_selectedGoalType == GoalType.weightLoss && targetWeight >= currentWeight) {
        setState(() {
          _targetWeightErrorText = 'Target must be less than current weight';
        });
        return;
      }

      if (_selectedGoalType == GoalType.muscleGain && targetWeight <= currentWeight) {
        setState(() {
          _targetWeightErrorText = 'Target must be greater than current weight';
        });
        return;
      }
    }

    if (_formKey.currentState!.validate() &&
        _selectedGender != null &&
        _selectedActivityLevel != null &&
        _selectedGoalType != null &&
        _selectedDateOfBirth != null &&
        age != null) {
      await ref.read(userProfileNotifierProvider.notifier).updateFullProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        dob: _selectedDateOfBirth!.toIso8601String().substring(0, 10),
        weight: currentWeight,
        height: double.tryParse(_heightController.text),
        age: age,
        gender: _selectedGender!.name,
        activityLevel: _selectedActivityLevel!.name,
      );

      final todayPlus30 = DateTime.now().add(const Duration(days: 30));
      final onlyDate = DateTime(todayPlus30.year, todayPlus30.month, todayPlus30.day);

      const double maintenanceCalories = 2200;
      const int kcalPerKg = 7700;
      const int durationDays = 30;

      final weightDelta = targetWeight - currentWeight;
      final totalKcalChange = weightDelta * kcalPerKg;
      final dailyAdjustment = totalKcalChange / durationDays;

      final calculatedCalories = maintenanceCalories + dailyAdjustment;

      final calculation = UserTargetCalculation(
        calculatedNormalCalories: calculatedCalories.round(),
        calculatedWeight: targetWeight,
        calculatedTargetDate: onlyDate,
      );

      await ref.read(userTargetCalculationNotifierProvider.notifier).addCalculation(calculation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text('Profile completed!'))),
        );
        context.go('/');
      }
    }
  }

  void _onSkip() {
    context.go('/');
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    final initialDate = _selectedDateOfBirth ?? DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(_selectedDateOfBirth);

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter first name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter last name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.isEmpty ? 'Enter phone number' : null,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _pickDateOfBirth(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'Select your date of birth',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _selectedDateOfBirth != null
                            ? "${_selectedDateOfBirth!.year}-${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}-${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}"
                            : '',
                      ),
                      validator: (_) {
                        if (_selectedDateOfBirth == null) {
                          return 'Select date of birth';
                        }

                        final today = DateTime.now();
                        final age = today.year - _selectedDateOfBirth!.year -
                            ((today.month < _selectedDateOfBirth!.month ||
                                (today.month == _selectedDateOfBirth!.month && today.day < _selectedDateOfBirth!.day))
                                ? 1
                                : 0);

                        if (age < 12) {
                          return 'You must be at least 12 years old';
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                if (age != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Your age: $age'),
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Gender>(
                  value: _selectedGender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender.name[0].toUpperCase() + gender.name.substring(1)),
                    );
                  }).toList(),
                  onChanged: (g) => setState(() => _selectedGender = g),
                  validator: (v) => v == null ? 'Select gender' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Enter weight';
                    }

                    final numValue = double.tryParse(v);
                    if (numValue == null) {
                      return 'Enter a valid number';
                    }

                    if (numValue < 30 || numValue > 200) {
                      return 'Weight must be between 30 and 200 kg';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Enter height';
                    }

                    final numValue = double.tryParse(v);
                    if (numValue == null) {
                      return 'Enter a valid number';
                    }

                    if (numValue < 120 || numValue > 240) {
                      return 'Height must be between 120 and 240 cm';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ActivityLevel>(
                  value: _selectedActivityLevel,
                  decoration: const InputDecoration(labelText: 'Activity Level'),
                  items: ActivityLevel.values.map((a) {
                    return DropdownMenuItem(
                      value: a,
                      child: Text(a.name[0].toUpperCase() + a.name.substring(1)),
                    );
                  }).toList(),
                  onChanged: (a) => setState(() => _selectedActivityLevel = a),
                  validator: (v) => v == null ? 'Select activity level' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<GoalType>(
                  value: _selectedGoalType,
                  decoration: const InputDecoration(labelText: 'Goal'),
                  items: GoalType.values.map((g) {
                    return DropdownMenuItem(
                      value: g,
                      child: Text(g.toString()),
                    );
                  }).toList(),
                  onChanged: (g) => setState(() => _selectedGoalType = g),
                  validator: (v) => v == null ? 'Select goal' : null,
                ),
                const SizedBox(height: 16),
                if (_shouldEnterTargetWeight)
                  TextFormField(
                    controller: _targetWeightController,
                    decoration: InputDecoration(
                      labelText: 'Target Weight (kg)',
                      errorText: _targetWeightErrorText,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter weight';
                      }

                      final numValue = double.tryParse(v);
                      if (numValue == null) {
                        return 'Enter a valid number';
                      }

                      if (numValue < 30 || numValue > 200) {
                        return 'Weight must be between 30 and 200 kg';
                      }

                      return null;
                    },
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _onSkip,
                        child: const Text('Skip'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSave,
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
