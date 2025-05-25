import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterController {
  static void register(BuildContext context, String username, String email, String password) {
      // TODO: Replace this with real API call to backend registration endpoint
      // Example: await AuthService.register(username, email, password);
      debugPrint('Register: $username / $email / $password');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registered as $username (placeholder)')),
      );

      // TODO: After successful registration, navigate to home or login
      context.go('/');
  }

  static void registerWithGoogle(BuildContext context) {
    // TODO: Implement Google Sign-In using Firebase Auth or OAuth
    // Example: await AuthService.signInWithGoogle();
    debugPrint('Google Register Pressed');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google register (placeholder)')),
    );

    // TODO: After successful Google registration, navigate to main screen
    // context.go('/');
  }
}