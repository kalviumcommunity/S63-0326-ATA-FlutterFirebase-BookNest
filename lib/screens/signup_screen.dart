import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'responsive_home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  void _signup() async {
    setState(() => _isLoading = true);

    final user = await _authService.signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      // Save their display name to Firestore!
      await _firestoreService.addUserData(user.uid, {
        'displayName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
        'role': 'user', // default role
      });

      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate and clear the backstack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ResponsiveHome()),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup Failed.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up for BookNest')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Display Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signup,
                    child: const Text('Sign Up'),
                  ),
          ],
        ),
      ),
    );
  }
}
