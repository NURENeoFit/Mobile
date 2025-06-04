/*
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/services/auth_service.dart';
import 'package:neofit_mobile/utils/auth_storage.dart';

class LoginController {
  static final _authService = AuthService();

  /// Log in using username and password (calls backend, saves token)
  static Future<void> loginWithUsername(
      BuildContext context, String username, String password) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      // Call backend for login and get token
      final token = await _authService.login(
        username: username,
        password: password,
      );

      if (token != null) {
        await AuthStorage.saveToken(token);

        messenger.showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );

        // Navigate to main screen
        context.go('/');
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text('Login failed, try again')),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  /// Google login (placeholder, implement real logic later)
  static void loginWithGoogle(BuildContext context) {
    debugPrint('Google login pressed');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google login (placeholder)')),
    );
    // TODO: Implement real Google OAuth logic and navigation if successful
    // context.go('/');
  }
}
*/
