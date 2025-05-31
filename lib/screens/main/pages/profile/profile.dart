import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildTile(
          context,
          Icons.person,
          'My details',
          onTap: () {
            context.push('/profile/details');
          },
        ),
        _buildTile(
          context,
          Icons.card_membership,
          'Abonnement',
          onTap: () {
            context.push('/profile/abonnement');
          }),
        _buildTile(
          context,
          Icons.star,
          'Favourites',
          onTap: () {
            context.push('/profile/favourites');
          }),
        _buildTile(
          context,
          Icons.stacked_bar_chart,
          'Statistics',
          onTap: () {
            context.push('/profile/statistics');
          }),
        _buildTile(
          context, 
          Icons.settings, 
          'Settings', 
          onTap: () {
            context.push('/profile/settings');
          }
        ),
        _buildTile(
          context,
          Icons.logout,
          'Logout',
          onTap: () {
            context.go('/login');
          },
        ),
      ],
    );
  }

  // Builds a ListTile wrapped in a Card
  Widget _buildTile(BuildContext context, IconData icon, String title,
      {String? subtitle, VoidCallback? onTap}) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: ColorScheme.of(context).surface,
      child: ListTile(
        splashColor: Colors.transparent,
        leading: Icon(icon, color: ColorScheme.of(context).primary, size: 24),
        title: Text(
          title,
          style: TextTheme.of(context).labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextTheme.of(context).bodySmall)
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
