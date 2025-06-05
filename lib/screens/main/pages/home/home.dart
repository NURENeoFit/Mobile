import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/providers/user/user_profile_provider.dart';
import 'package:neofit_mobile/providers/user/user_target_calculation_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/providers/schedule/training_provider.dart';
import 'package:neofit_mobile/providers/membership/membership_provider.dart';
import 'goal_block.dart';

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
      return Scaffold(
        body: Center(
          child: Text('Error loading data. Check your internet connection.'),
        ),
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
            membershipAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => const SizedBox.shrink(),
              data: (membership) {
                final endDate = membership?.endDate;
                final displayDate = endDate != null ? _formatDate(endDate) : '—';
                return Material(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context.push('/profile/abonnement'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Membership active\nuntil $displayDate',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSecondary),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            GoalBlock(
              profileAsync: profileAsync,
              calcAsync: calcAsync,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Schedule', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TableCalendar(
                    calendarFormat: CalendarFormat.week,
                    availableCalendarFormats: const {
                      CalendarFormat.week: 'Week',
                    },
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Plans for ${selected.toLocal().toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...plans.map((training) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.fitness_center, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${training.specializationName} with ${training.fullNameTrainer}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${training.startTime} • ${training.isGroup ? 'Group' : 'Individual'}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (plans.isEmpty)
                    Text(
                      'No plans for this date.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${_monthName(date.month)} ${date.day}';
    } catch (_) {
      return '—';
    }
  }

  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}
