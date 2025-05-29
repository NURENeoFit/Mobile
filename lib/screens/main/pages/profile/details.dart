import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated user data
    final String username = 'anna.smith';
    final String email = 'anna@example.com';
    final String phone = '+1234567890';
    final String dateOfBirth = '2006-04-15';

    final String firstName = 'Anna';
    final String lastName = 'Smith';
    final String gender = 'Female';
    final String age = '18';
    final String height = '170 cm';
    final String weight = '65.0 kg';
    final String units = 'kg / cm';
    final String target = 'Build muscles';

    // Recommendation data
    final Map<String, String> recommendations = {
      'Calorie intake': '2509',
      'Water intake': '2,5 l',
      'Steps per day': '8 000',
    };

    // Account info section
    final Map<String, String?> accountDetails = {
      'Username': username,
      'Email': email,
      'Phone': phone,
      'Date of birth': dateOfBirth,
      'Change password': null, // functional item
    };

    final Map<String, VoidCallback> accountActions = {
      'Change password': () {
        // TODO: implement password change logic
        debugPrint('Change password tapped');
      },
    };

    // Profile info section
    final Map<String, String?> profileDetails = {
      'Name': '$firstName $lastName',
      'Gender': gender,
      'Age': age,
      'Height': height,
      'Weight': weight,
      'Units of measurement': units,
      'Target': target,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FA),
      appBar: AppBar(title: Text('My details', style: TextTheme.of(context).headlineLarge)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCardSection(
            context: context,
            title: 'Account',
            entries: accountDetails,
            tapActions: accountActions,
          ),
          const SizedBox(height: 24),
          _buildCardSection(
            context: context,
            title: 'Profile',
            entries: profileDetails,
          ),
          const SizedBox(height: 24),
          _buildCardSection(
            context: context,
            title: 'Recommendations',
            entries: recommendations,
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection({
    required BuildContext context,
    required Map<String, String?> entries,
    String? title,
    Map<String, VoidCallback>? tapActions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: TextTheme.of(context).bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorScheme.of(context).onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: ColorScheme.of(context).surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(entries.length, (index) {
              final entry = entries.entries.elementAt(index);
              final onTap = tapActions?[entry.key];

              return Column(
                children: [
                  ListTile(
                    title: Text(entry.key, style: TextTheme.of(context).bodyMedium?.copyWith(
                      color: ColorScheme.of(context).onSurface,
                    )),
                    trailing: entry.value != null
                        ? Text(
                      entry.value!,
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        color: ColorScheme.of(context).primary,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: onTap,
                  ),
                  if (index < entries.length - 1)
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
