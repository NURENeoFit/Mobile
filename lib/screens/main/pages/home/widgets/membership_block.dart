import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MembershipCard extends StatelessWidget {
  final AsyncValue membershipAsync;

  const MembershipCard({super.key, required this.membershipAsync});

  @override
  Widget build(BuildContext context) {
    return membershipAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (membership) {
        final endDate = membership?.endDate;
        String displayDate = '—';

        try {
          if (endDate != null) {
            final date = DateTime.parse(endDate);
            displayDate = '${_monthName(date.month)} ${date.day}';
          }
        } catch (_) {
          displayDate = endDate ?? '—';
        }

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
                  Icon(Icons.chevron_right,
                      color: Theme.of(context).colorScheme.onSecondary),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}
