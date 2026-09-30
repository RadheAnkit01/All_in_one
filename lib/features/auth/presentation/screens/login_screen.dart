import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullPhoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(loginProvider.notifier)
        .login(
          fullPhoneNumber: _fullPhoneController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    ref.listen(loginProvider, (previous, next) {
      next.whenOrNull(
        data: (session) {
          if (session == null) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome ${session.user.fname}')),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fullPhoneController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone Number is required';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: loginState.isLoading ? null : _login,
                child: loginState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
