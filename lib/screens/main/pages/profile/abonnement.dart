import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AbonnementPage extends StatelessWidget {
  const AbonnementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Simulated active membership data
    final Map<String, dynamic>? activeMembership = {
      'membership_name': 'Premium Membership',
      'membership_description': 'Access to gym and unlimited group classes',
      'membership_price': '129',
      'start_date': '2025-05-01',
      'end_date': '2025-06-30',
      'qr_data': const Uuid().v4(),
    };

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // QR code at the top
            Center(
              child: Column(
                children: [
                  Text('Your QR Code', style: textTheme.titleLarge),
                  const SizedBox(height: 10),
                  QrImageView(
                    data: activeMembership['qr_data'],
                    version: QrVersions.auto,
                    size: 200,
                  ),
                  const SizedBox(height: 8),
                  Text('QR: ${activeMembership['qr_data']}', style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
}
