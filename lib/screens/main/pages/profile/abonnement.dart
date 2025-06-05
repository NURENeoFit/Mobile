import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/providers/membership/membership_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class AbonnementPage extends ConsumerStatefulWidget {
  const AbonnementPage({super.key});

  @override
  ConsumerState<AbonnementPage> createState() => _AbonnementPageState();
}

class _AbonnementPageState extends ConsumerState<AbonnementPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(membershipNotifierProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final membershipAsync = ref.watch(membershipNotifierProvider);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Abonnement', style: textTheme.headlineMedium)),
      body: membershipAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (membership) {
          if (membership == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.card_membership, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Your current abonnement will appear here.',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final qrData = jsonEncode(membership.toJson());
          final isActive = _checkMembershipActive(membership.startDate, membership.endDate);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text('Your QR Code', style: textTheme.titleLarge),
                      const SizedBox(height: 10),
                      QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Status:', style: textTheme.titleMedium),
                Text(
                  isActive ? 'Active' : 'Inactive',
                  style: textTheme.titleMedium?.copyWith(
                    color: isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Text('Membership Name:', style: textTheme.titleMedium),
                Text(membership.name, style: textTheme.bodyLarge),
                const SizedBox(height: 12),

                Text('Description:', style: textTheme.titleMedium),
                Text(membership.description, style: textTheme.bodyLarge),
                const SizedBox(height: 12),

                Text('Price:', style: textTheme.titleMedium),
                Text('${membership.price} USD', style: textTheme.bodyLarge),
                const SizedBox(height: 12),

                Text('Active Period:', style: textTheme.titleMedium),
                Text(
                  '${membership.startDate} - ${membership.endDate}',
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _checkMembershipActive(String? start, String? end) {
    if (start == null || end == null) return false;
    try {
      final now = DateTime.now();
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);
      return now.isAfter(startDate) && now.isBefore(endDate.add(const Duration(days: 1)));
    } catch (_) {
      return false;
    }
  }
}