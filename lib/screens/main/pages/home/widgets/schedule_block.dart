import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleBlock extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final List plans;
  final void Function(DateTime selected, DateTime focused) onDaySelected;

  const ScheduleBlock({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.plans,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedDay ?? focusedDay;

    return Container(
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
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: onDaySelected,
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
          if (plans.isEmpty)
            Text(
              'No plans for this date.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              ),
            ),
          ...plans.map<Widget>((training) {
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
                          '${training.startTime} - ${training.endTime}',
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
        ],
      ),
    );
  }
}
