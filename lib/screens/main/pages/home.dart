import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/providers/training_provider.dart';
import 'package:neofit_mobile/providers/membership_provider.dart';

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
    // Trigger refresh when entering page
    Future.microtask(() {
      ref.read(trainingNotifierProvider.notifier).refresh();
      ref.read(membershipNotifierProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedDay ?? _focusedDay;
    final trainingAsync = ref.watch(trainingNotifierProvider);
    final membershipAsync = ref.watch(membershipNotifierProvider);

    return trainingAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (plansMap) {
        final selectedKey = DateTime.utc(selected.year, selected.month, selected.day);
        final plans = plansMap[selectedKey] ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Membership
              membershipAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
                data: (membership) {
                  final endDate = membership?.endDate;
                  final displayDate = endDate != null ? _formatDate(endDate) : '—';

                  return Material(
                    color: ColorScheme.of(context).secondary,
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
                              style: TextTheme.of(context).bodyLarge?.copyWith(
                                color: ColorScheme.of(context).onSecondary,
                              ),
                            ),
                            Icon(Icons.chevron_right, color: ColorScheme.of(context).onSecondary),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Goal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorScheme.of(context).surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🎯 Goal', style: TextTheme.of(context).bodyLarge),
                    const SizedBox(height: 4),
                    Text('Weight loss', style: TextTheme.of(context).titleMedium),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: ColorScheme.of(context).onSurface.withAlpha(25),
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '5 kg left',
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        color: ColorScheme.of(context).onSurface.withAlpha(100),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Calendar block + plans
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorScheme.of(context).surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Schedule', style: TextTheme.of(context).titleMedium),
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
                          color: ColorScheme.of(context).primary,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: ColorScheme.of(context).tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Plans for ${selected.toLocal().toString().split(' ')[0]}',
                      style: TextTheme.of(context).bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...plans.map((training) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColorScheme.of(context).surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.fitness_center, color: ColorScheme.of(context).primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${training.type} with ${training.fullNameTrainer}',
                                    style: TextTheme.of(context).bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${training.time.format(context)} • ${training.isGroup ? 'Group' : 'Individual'}',
                                    style: TextTheme.of(context).bodyMedium?.copyWith(
                                      color: ColorScheme.of(context).onSurface.withAlpha(100),
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
                        style: TextTheme.of(context).bodyMedium?.copyWith(
                          color: ColorScheme.of(context).onSurface.withAlpha(100),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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
