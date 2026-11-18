import 'package:flutter/material.dart';

import 'demo_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void register() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    DemoAuth.register(usernameController.text.trim(), passwordController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful! You can now log in.'),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final username = (value ?? '').trim();
                        if (username.length < 3) {
                          return 'Use at least three characters.';
                        }
                        if (username.toLowerCase() == 'admin') {
                          return 'The username admin is reserved.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value ?? '').length < 6
                          ? 'Use at least six characters.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: confirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value != passwordController.text
                          ? 'Passwords must match.'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: register,
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
