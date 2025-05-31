import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
  }

  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool('notifications_enabled') ?? true;
    setState(() {
      notifications = savedValue;
      _loaded = true;
    });
  }

  Future<void> _saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildTile(
            context,
            Icons.person,
            'Edit Profile',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile tapped')),
              );
            },
          ),
          _buildTile(
            context,
            Icons.flag,
            'Edit Goal',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Goal tapped')),
              );
            },
          ),
          _buildTile(
            context,
            Icons.lock,
            'Change Password',
            onTap: () {
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
            (val) {
              setState(() => notifications = val);
              _saveNotificationSetting(val);
            },
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
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        splashColor: Colors.transparent,
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall)
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, IconData icon, String title,
      bool value, ValueChanged<bool> onChanged) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Theme.of(context).colorScheme.surface,
      child: !_loaded
          ? ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          )
        ),
        trailing: const SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      )
          : ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
