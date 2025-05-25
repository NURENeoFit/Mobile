import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginController {
  static void loginWithUsername(BuildContext context, String username, String password) {
    // TODO: Add real auth logic
    debugPrint('Login with username: $username, password: $password');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged in as $username (placeholder)')),
    );

    context.go('/');
  }

  static void loginWithGoogle(BuildContext context) {
    // TODO: Google Sign-In logic
    debugPrint('Google login pressed');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google login (placeholder)')),
    );
  }
}
