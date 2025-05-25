import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  void _loginWithUsername() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // TODO: Replace with real authentication logic
      debugPrint('Login with username: $username, password: $password');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged in as $username (placeholder)')),
      );

      context.go("/");
    }
  }

  void _loginWithGoogle() {
    // TODO: Implement real Google Sign-In logic
    debugPrint('Google Sign-In pressed');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google login (placeholder)')),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child:  Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.lock, size: 64, color: Colors.deepPurple),
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
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
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
                  onPressed: _loginWithUsername,
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),

              // Divider
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              // Google login
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                  onPressed: _loginWithGoogle,
                ),
              ),

              const SizedBox(height: 24),

              // Register link
              TextButton(
                onPressed: () {
                  // TODO: Implement navigation to register screen
                  debugPrint('Go to register screen (placeholder)');
                },
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
