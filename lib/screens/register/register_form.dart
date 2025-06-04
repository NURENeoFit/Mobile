import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/providers/registration_provider.dart';
import 'package:neofit_mobile/services/backend_auth_service.dart';
import 'package:neofit_mobile/services/google_auth_service.dart';
import 'package:neofit_mobile/widgets/or_divider.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      ref.read(registrationProvider.notifier).register(
        username: _usernameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
    }
  }

  void _onGooglePressed() async {
    final googleAuth = await GoogleAuthService().signIn();
    if (googleAuth?.idToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google sign-in failed!')),
      );
      return;
    }
    final backendToken = await BackendAuthService().signInWithGoogleIdToken(googleAuth!.idToken!);
    if (backendToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google registration failed on server!')),
      );
      return;
    }

    // Optionally save backendToken to secure storage!
    // For example: await AuthStorage.saveToken(backendToken);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration via Google successful!')),
    );
    context.go('/'); // Go to main page or home page
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);

    ref.listen(registrationProvider, (previous, next) {
      if (previous?.status != RegistrationStatus.success &&
          next.status == RegistrationStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        // context.go('/personal_info');
        context.go('/');
      }
      if (next.status == RegistrationStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? 'Registration error')),
        );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.person_add, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),

          // Username
          TextFormField(
            controller: _usernameCtrl,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Enter your username' : null,
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter your email';
              if (!value.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter password';
              if (value.length < 6) return 'Password too short';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm password
          TextFormField(
            controller: _confirmPasswordCtrl,
            obscureText: _obscure,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != _passwordCtrl.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Sign up button
          SizedBox(
            width: double.infinity,
            child: state.status == RegistrationStatus.loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _onRegisterPressed,
              child: Text('Sign Up', style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          const SizedBox(height: 16),
          const CustomDivider(),
          const SizedBox(height: 16),

          // Google
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Sign up with Google'),
              onPressed: _onGooglePressed,
            ),
          ),
          const SizedBox(height: 24),

          // Login link
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }
}
