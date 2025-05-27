import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildTile(
          Icons.person,
          'My details',
          onTap: () {
            context.push('/profile/details');
          },
        ),
        _buildTile(
          Icons.card_membership,
          'Abonnement',
          onTap: () {
            context.push('/profile/abonnement');
          }),
        _buildTile(Icons.star, 'Favourites', onTap: () {}),
        _buildTile(Icons.stacked_bar_chart, 'Statistics', onTap: () {}),
        _buildSwitchTile(
          Icons.notifications,
          'Notifications',
          notifications,
              (val) => setState(() => notifications = val),
        ),
        _buildTile(Icons.settings, 'Settings', onTap: () {}),
        _buildTile(
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
  Widget _buildTile(IconData icon, String title,
      {String? subtitle, VoidCallback? onTap}) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      child: ListTile(
        splashColor: Colors.transparent,
        leading: Icon(icon, color: Colors.deepPurple, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Colors.grey))
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // Builds a ListTile with a switch
  Widget _buildSwitchTile(
      IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: Colors.deepPurple, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
      ),
    );
  }
}
