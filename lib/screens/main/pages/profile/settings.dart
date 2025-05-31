import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings', style: TextTheme.of(context).headlineMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildTile(
            context,
            Icons.person,
            'Edit Profile',
            // onTap: () => context.push('/profile/details'),
          ),
          _buildTile(
            context,
            Icons.flag,
            'Edit Goal',
            onTap: () {
              // TODO: push to edit goals screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Goals tapped')),
              );
            },
          ),
          _buildTile(
            context,
            Icons.lock,
            'Change Password',
            onTap: () {
              // TODO: push to password change screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change Password tapped')),
              );
            },
          ),
          _buildSwitchTile(
            context,
            Icons.notifications,
            'Notifications',
            notifications,
                (val) => setState(() => notifications = val),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title,
      {String? subtitle, VoidCallback? onTap}) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: ColorScheme.of(context).surface,
      child: ListTile(
        splashColor: Colors.transparent,
        leading: Icon(icon, color: ColorScheme.of(context).primary),
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

  // Builds a ListTile with a switch
  Widget _buildSwitchTile(BuildContext context, IconData icon, String title,
      bool value, ValueChanged<bool> onChanged) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: ColorScheme.of(context).surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: ColorScheme.of(context).primary, size: 24),
        title: Text(
          title,
          style: TextTheme.of(context).labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
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
