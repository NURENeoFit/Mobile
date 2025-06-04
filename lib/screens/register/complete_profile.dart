import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/models/user/program_goal.dart';
import 'package:neofit_mobile/models/user/personal_user_data.dart';
import 'package:neofit_mobile/providers/user_profile_provider.dart';

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

  Gender? _selectedGender;
  ActivityLevel? _selectedActivityLevel;
  GoalType? _selectedGoalType;
  DateTime? _selectedDateOfBirth;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // Helper to calculate age from birth date
  int? _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return null;
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Save button handler: validates and saves profile, then navigates to main page
  Future<void> _onSave() async {
    final age = _calculateAge(_selectedDateOfBirth);
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
        dob: _selectedDateOfBirth!.toIso8601String().substring(0, 10), // "YYYY-MM-DD"
        weight: double.tryParse(_weightController.text),
        height: double.tryParse(_heightController.text),
        age: age,
        gender: _selectedGender!.name,
        activityLevel: _selectedActivityLevel!.name,
        // goalId если нужно для бэка — добавь здесь
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text('Profile completed!'))),
        );
        context.go('/');
      }
    }
  }

  // Skip button handler: just goes to the main page
  void _onSkip() {
    context.go('/');
  }

  // Show date picker for date of birth
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
                // First Name
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter first name' : null,
                ),
                const SizedBox(height: 16),
                // Last Name
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter last name' : null,
                ),
                const SizedBox(height: 16),
                // Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.isEmpty ? 'Enter phone number' : null,
                ),
                const SizedBox(height: 16),
                // Date of Birth
                GestureDetector(
                  onTap: () => _pickDateOfBirth(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'Select your date of birth',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _selectedDateOfBirth != null
                            ? "${_selectedDateOfBirth!.year}-${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}-${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}"
                            : '',
                      ),
                      validator: (_) => _selectedDateOfBirth == null ? 'Select date of birth' : null,
                    ),
                  ),
                ),
                if (age != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Your age: $age'),
                  ),
                const SizedBox(height: 16),
                // Gender
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
                // Weight
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Enter weight' : null,
                ),
                const SizedBox(height: 16),
                // Height
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Enter height' : null,
                ),
                const SizedBox(height: 16),
                // Activity Level
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
                // Goal type
                DropdownButtonFormField<GoalType>(
                  value: _selectedGoalType,
                  decoration: const InputDecoration(labelText: 'Goal'),
                  items: GoalType.values.map((g) {
                    return DropdownMenuItem(
                      value: g,
                      child: Text(_goalTypeToString(g)),
                    );
                  }).toList(),
                  onChanged: (g) => setState(() => _selectedGoalType = g),
                  validator: (v) => v == null ? 'Select goal' : null,
                ),
                const SizedBox(height: 24),
                // Buttons row: Skip and Save (Skip first)
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

  // Converts GoalType enum to user-friendly string
  String _goalTypeToString(GoalType g) {
    switch (g) {
      case GoalType.weightLoss:
        return 'Weight Loss';
      case GoalType.muscleGain:
        return 'Muscle Gain';
      case GoalType.endurance:
        return 'Endurance';
      case GoalType.generalFitness:
        return 'General Fitness';
    }
  }
}
