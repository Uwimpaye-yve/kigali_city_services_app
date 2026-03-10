import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;

  void _submit() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    String? error;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      ),
    );

    if (isLogin) {
      error = await auth.logIn(_emailController.text.trim(), _passwordController.text);
    } else {
      error = await auth.signUp(_emailController.text.trim(), _passwordController.text);
    }

    // Hide loading
    if (mounted) Navigator.pop(context);

    if (error != null && mounted) {
      // Show user-friendly error
      String friendlyError = error;
      if (error.contains('network')) {
        friendlyError = 'Network error. Please check your internet connection and ensure Firebase Authentication is enabled in Firebase Console.';
      } else if (error.contains('email-already-in-use')) {
        friendlyError = 'This email is already registered. Please login instead.';
      } else if (error.contains('weak-password')) {
        friendlyError = 'Password is too weak. Use at least 6 characters.';
      } else if (error.contains('invalid-email')) {
        friendlyError = 'Invalid email address.';
      } else if (error.contains('user-not-found')) {
        friendlyError = 'No account found with this email.';
      } else if (error.contains('wrong-password')) {
        friendlyError = 'Incorrect password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(friendlyError),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } else if (!isLogin && mounted) {
      // Show success message for signup
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created! Please check your email to verify.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // Dark Navy matching the UI
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_city, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              isLogin ? "Welcome Back" : "Create Account",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.white10,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Colors.white10,
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: _submit,
                child: Text(isLogin ? "LOGIN" : "SIGN UP"),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin
                    ? "Don't have an account? Sign Up"
                    : "Already have an account? Login",
                style: const TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
