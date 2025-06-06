import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/providers/user/user_profile_provider.dart';
import 'package:neofit_mobile/providers/schedule/training_provider.dart';
import 'package:neofit_mobile/providers/membership/membership_provider.dart';
import 'package:neofit_mobile/providers/user/user_target_calculation_provider.dart';
import 'package:neofit_mobile/screens/main/pages/home/widgets/schedule_block.dart';
import 'package:neofit_mobile/screens/main/pages/home/widgets/goal_block.dart';
import 'package:neofit_mobile/screens/main/pages/home/widgets/membership_block.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userTargetCalculationNotifierProvider.notifier).refresh();
      ref.read(userProfileNotifierProvider.notifier).refresh();
      ref.read(trainingNotifierProvider.notifier).refresh();
      ref.read(membershipNotifierProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedDay ?? _focusedDay;

    final trainingAsync = ref.watch(trainingNotifierProvider);
    final membershipAsync = ref.watch(membershipNotifierProvider);
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final calcAsync = ref.watch(userTargetCalculationNotifierProvider);

    final isLoading = trainingAsync.isLoading ||
        membershipAsync.isLoading ||
        profileAsync.isLoading ||
        calcAsync.isLoading;

    final hasError = trainingAsync.hasError ||
        membershipAsync.hasError ||
        profileAsync.hasError ||
        calcAsync.hasError;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(child: Text('Failed to update profile'))),
      );
    }

    final plansMap = trainingAsync.value ?? {};
    final selectedKey = DateTime.utc(selected.year, selected.month, selected.day);
    final plans = plansMap[selectedKey] ?? [];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MembershipCard(membershipAsync: membershipAsync),
            const SizedBox(height: 16),

            GoalBlock(
              profileAsync: profileAsync,
              calcAsync: calcAsync,
            ),
            const SizedBox(height: 16),

            ScheduleBlock(
              selectedDay: _selectedDay,
              focusedDay: _focusedDay,
              plans: plans,
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
