import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class AbonnementPage extends StatelessWidget {
  const AbonnementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Simulated active membership data
    final Map<String, dynamic>? activeMembership = {
      'user_id': '123456',
      'membership_name': 'Premium Membership',
      'membership_description': 'Access to gym and unlimited group classes',
      'membership_price': '129',
      'start_date': '2025-05-01',
      'end_date': '2025-06-30',
    };

    // Convert membership data to JSON for QR code
    final String qrData = jsonEncode(activeMembership);

    // Check if membership is active
    final isActive = _checkMembershipActive(
      activeMembership?['start_date'],
      activeMembership?['end_date'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Abonnement', style: textTheme.headlineMedium),
      ),
      body: activeMembership == null
          ? Center(
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
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // QR code section
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

            // Membership status
            Text('Status: ', style: textTheme.titleMedium),
            Text(
              isActive ? 'Active' : 'Inactive',
              style: textTheme.titleMedium?.copyWith(
                color: isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Membership details
            Text('Membership Name:', style: textTheme.titleMedium),
            Text(activeMembership['membership_name'], style: textTheme.bodyLarge),
            const SizedBox(height: 12),

            Text('Description:', style: textTheme.titleMedium),
            Text(activeMembership['membership_description'], style: textTheme.bodyLarge),
            const SizedBox(height: 12),

            Text('Price:', style: textTheme.titleMedium),
            Text('${activeMembership['membership_price']} USD', style: textTheme.bodyLarge),
            const SizedBox(height: 12),

            Text('Active Period:', style: textTheme.titleMedium),
            Text(
              '${activeMembership['start_date']} - ${activeMembership['end_date']}',
              style: textTheme.bodyLarge,
            ),
          ],
        ),
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
