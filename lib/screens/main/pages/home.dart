import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('NeoFit')),
      backgroundColor: const Color(0xFFF8F5FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Membership
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Membership active\nuntil June 30', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Goal
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🎯 Goal', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Weight loss', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  const Text('5 kg left', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Calendar block + plans
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Plans for ${selected.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._getPlansForDay(selected).map((training) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.fitness_center, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${training.type} with ${training.coach}',
                                    style: const TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 4),
                                Text(
                                  '${training.time.format(context)} • ${training.isGroup ? 'Group' : 'Individual'}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (_getPlansForDay(selected).isEmpty)
                    const Text('No plans for this date.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
