import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:neofit_mobile/design/dimensions.dart';

class Training {
  final TimeOfDay time;
  final String coach;
  final String type;
  final bool isGroup;

  const Training({
    required this.time,
    required this.coach,
    required this.type,
    required this.isGroup,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final String activeData = 'June 30';

  final Map<DateTime, List<Training>> _plans = {
    DateTime.utc(2025, 5, 28): [
      Training(time: TimeOfDay(hour: 9, minute: 30), coach: 'Anna', type: 'Leg Day', isGroup: true),
    ],
    DateTime.utc(2025, 5, 29): [
      Training(time: TimeOfDay(hour: 14, minute: 0), coach: 'Mike', type: 'Cardio', isGroup: false),
    ],
    DateTime.utc(2025, 5, 30): [
      Training(time: TimeOfDay(hour: 11, minute: 0), coach: 'Sara', type: 'Upper Body', isGroup: true),
      Training(time: TimeOfDay(hour: 13, minute: 15), coach: 'Leo', type: 'Stretching', isGroup: false),
    ],
  };

  List<Training> _getPlansForDay(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    return _plans[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedDay ?? _focusedDay;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // Membership
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorScheme.of(context).secondary,
              borderRadius: containerBorderRadius12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Membership active\nuntil $activeData',
                  style: TextTheme.of(context).bodyLarge?.copyWith(
                      color: ColorScheme.of(context).onSecondary,
                  )
                ),
                Icon(
                  Icons.chevron_right,
                  color: ColorScheme.of(context).onSecondary
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Goal
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorScheme.of(context).surface,
              borderRadius: containerBorderRadius12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 Goal',
                  style: TextTheme.of(context).bodyLarge
                ),
                const SizedBox(height: 4),
                Text(
                  'Weight loss',
                  style: TextTheme.of(context).titleLarge
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: ColorScheme.of(context).onSurface.withValues(alpha: 0.1),
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  '5 kg left',
                  style: TextTheme.of(context).bodyMedium?.copyWith(
                      color: ColorScheme.of(context).onSurface.withValues(alpha: 0.4)
                  )
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
              borderRadius: containerBorderRadius12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Schedule',
                  style: TextTheme.of(context).titleLarge
                ),
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
                  style: TextTheme.of(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 8),
                ..._getPlansForDay(selected).map((training) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorScheme.of(context).surfaceContainer,
                      borderRadius: containerBorderRadius12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          color: ColorScheme.of(context).primary
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${training.type} with ${training.coach}',
                                style: TextTheme.of(context).bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500
                                )
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${training.time.format(context)} • ${training.isGroup ? 'Group' : 'Individual'}',
                                style: TextTheme.of(context).bodyMedium?.copyWith(
                                    color: ColorScheme.of(context).onSurface.withValues(alpha: 0.4)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                if (_getPlansForDay(selected).isEmpty)
                  Text(
                    'No plans for this date.',
                    style: TextStyle(color: ColorScheme.of(context).onSurface.withValues(alpha: 0.4))
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
