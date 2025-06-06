import 'package:flutter/material.dart';
import 'package:neofit_mobile/models/user_target_calculation.dart';

class StatisticsHistory extends StatefulWidget {
  final List<UserTargetCalculation> weightData;
  const StatisticsHistory({required this.weightData});

  @override
  State<StatisticsHistory> createState() => _StatisticsHistoryState();
}

class _StatisticsHistoryState extends State<StatisticsHistory> {
  bool _historyExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 2,
      color: colorScheme.surface,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _historyExpanded = !_historyExpanded;
              });
            },
            child: Container(
              color: colorScheme.primary.withAlpha(30),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: Icon(Icons.history, color: colorScheme.onSurface),
                title: Text('History', style: textTheme.titleSmall),
                trailing: AnimatedRotation(
                  turns: _historyExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more, color: colorScheme.onSurface),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: child,
              );
            },
            child: _historyExpanded
                ? Column(
              key: const ValueKey(true),
              children: [
                for (int i = 0; i < widget.weightData.length; i++) ...[
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(Icons.insights, color: colorScheme.onPrimaryContainer),
                    ),
                    title: Text(
                      'Date: ${widget.weightData[i].calculatedTargetDate.toIso8601String().split('T').first}',
                      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Weight: ${widget.weightData[i].calculatedWeight} kg | Calories: ${widget.weightData[i].calculatedNormalCalories} kcal',
                      style: textTheme.bodySmall,
                    ),
                  ),
                  if (i < widget.weightData.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                ]
              ],
            )
                : const SizedBox.shrink(key: ValueKey(false)),
          ),
        ],
      ),
    );
  }
}
