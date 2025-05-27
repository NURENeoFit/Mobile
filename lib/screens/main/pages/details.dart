import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated user data
    final String firstName = 'Anna';
    final String lastName = 'Smith';
    final String gender = 'Female';
    final String age = '18';
    final String height = '170 cm';
    final String weight = '65.0 kg';
    final String units = 'kg / cm';
    final String target = 'Build muscles';

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
      appBar: AppBar(title: const Text('My details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 24),
          _buildCardSection(
            title: 'Profile',
            entries: profileDetails,
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection({
    required Map<String, String?> entries,
    String? title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(entries.length, (index) {
              final entry = entries.entries.elementAt(index);

              return Column(
                children: [
                  ListTile(
                    title: Text(entry.key, style: const TextStyle(color: Colors.black)),
                    trailing: entry.value != null
                        ? Text(
                      entry.value!,
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
