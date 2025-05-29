import 'package:flutter/material.dart';
import 'package:neofit_mobile/screens/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text('Login', style: TextTheme.of(context).headlineMedium)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: LoginForm(),
      ),
    );
  }
}
