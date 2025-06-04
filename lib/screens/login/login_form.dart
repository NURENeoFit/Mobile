import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/providers/login_provider.dart';
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

  void _onGooglePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google login (placeholder)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);

    ref.listen(loginProvider, (previous, next) {
      if (next.status == LoginStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        context.go('/'); // Go to main screen
      }
      if (next.status == LoginStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? 'Login error')),
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
            child: state.status == LoginStatus.loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _onLoginPressed,
              child: Text('Login', style: Theme.of(context).textTheme.labelLarge),
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
