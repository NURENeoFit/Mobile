import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/models/user/full_user_profile.dart';
import 'package:neofit_mobile/providers/user/user_profile_provider.dart';

class DetailsPage extends ConsumerStatefulWidget {
  const DetailsPage({super.key});

  @override
  ConsumerState<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userProfileNotifierProvider.notifier).refresh();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileNotifierProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('My details')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (profile) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text('My details', style: Theme.of(context).textTheme.headlineMedium),
            actions: profile != null
                ? [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.push('/complete-profile?edit=true');
                },
              ),
            ]
                : [],
          ),
          body: profile == null
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, size: 64, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Your profile details will be displayed here.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          )
              : _buildProfileContent(context, profile),
        );
      },
    );
  }

  Widget _buildProfileContent(BuildContext context, FullUserProfile profile) {
    final user = profile.user;
    final accountDetails = {
      'Username': user.username,
      'Email': user.userEmail,
      'Phone': user.userPhone,
      'Date of birth': user.userDob.toIso8601String().split('T').first,
    };

    final personal = profile.personalData;
    final profileDetails = {
      'Name': '${user.userFirstName} ${user.userLastName}',
      'Gender': personal.gender.name[0].toUpperCase() + personal.gender.name.substring(1),
      'Age': personal.age.toString(),
      'Height': '${personal.heightCm.round()} cm',
      'Weight': '${personal.weightKg} kg',
      'Units of measurement': 'kg / cm',
      'Target': personal.goal.toString(),
    };

    final recommendations = {
      'Calorie intake': '2509',
      'Water intake': '2,5 l',
      'Steps per day': '8 000',
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCardSection(context: context, title: 'Account', entries: accountDetails),
        const SizedBox(height: 24),
        _buildCardSection(context: context, title: 'Profile', entries: profileDetails),
        const SizedBox(height: 24),
        _buildCardSection(context: context, title: 'Recommendations', entries: recommendations),
      ],
    );
  }

  Widget _buildCardSection({
    required BuildContext context,
    required Map<String, String?> entries,
    String? title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(entries.length, (index) {
              final entry = entries.entries.elementAt(index);

              return Column(
                children: [
                  ListTile(
                    title: Text(entry.key, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                    trailing: entry.value != null
                        ? Text(
                      entry.value!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
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
