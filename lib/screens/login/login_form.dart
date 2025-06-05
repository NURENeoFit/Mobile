import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/providers/login_provider.dart';
import 'package:neofit_mobile/services/google/backend_auth_service.dart';
import 'package:neofit_mobile/services/google/google_auth_service.dart';
import 'package:neofit_mobile/widgets/or_divider.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      ref.read(loginProvider.notifier).login(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  void _onGooglePressed() async {
    final googleAuth = await GoogleAuthService().signIn();
    if (googleAuth?.idToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text('Google sign-in failed!'))),
      );
      return;
    }
    final backendToken = await BackendAuthService().signInWithGoogleIdToken(googleAuth!.idToken!);
    if (backendToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text('Google login failed on server!'))),
      );
      return;
    }

    // Optionally save backendToken to secure storage!
    // await AuthStorage.saveToken(backendToken);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Center(child: Text('Login via Google successful!'))),
    );
    context.go('/'); // Go to main page or home page
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);

    ref.listen(loginProvider, (previous, next) {
      if (next.status == LoginStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text('Login successful!'))),
        );
        context.go('/'); // Go to main screen
      }
      if (next.status == LoginStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text('Login error'))),
        );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 60),
          Icon(Icons.lock, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          // Username
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Enter your username' : null,
          ),
          const SizedBox(height: 16),
          // Password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() => _obscure = !_obscure);
                },
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Enter your password' : null,
          ),
          const SizedBox(height: 24),
          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.status == LoginStatus.loading ? null : _onLoginPressed,
              child: state.status == LoginStatus.loading
                  ? SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
                  : Text('Login', style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          const SizedBox(height: 16),
          const CustomDivider(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
              onPressed: _onGooglePressed,
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => context.go("/register"),
            child: const Text("Don't have an account? Sign up"),
          ),
        ],
      ),
    );
  }
}
