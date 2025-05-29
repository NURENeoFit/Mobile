import 'package:flutter/material.dart';
import 'package:neofit_mobile/screens/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text('Register', style: TextTheme.of(context).headlineMedium)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: RegisterForm(),
      ),
    );
  }
}
