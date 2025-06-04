/*
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/services/auth_service.dart';
import 'package:neofit_mobile/utils/auth_storage.dart';

class RegisterController {
  static final _authService = AuthService();

  static Future<void> register(
      BuildContext context, String username, String email, String password) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      // Call backend for registration, save token
      final token = await _authService.register(
        username: username,
        email: email,
        password: password,
      );

      if (token != null) {
        await AuthStorage.saveToken(token);

        messenger.showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );

        // Navigate to home or main screen
        context.go('/');
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text('Registration failed, try again')),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  static void registerWithGoogle(BuildContext context) {
    // TODO: Implement real Google OAuth registration here
    debugPrint('Google Register Pressed');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google register (placeholder)')),
    );
    // context.go('/');
  }
}
*/
