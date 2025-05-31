import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text('Settings', style: TextTheme.of(context).headlineMedium)),
      body: SafeArea(
        child: Center(
          child: Text('Test'),
        )
      )
    );
  }
  
}