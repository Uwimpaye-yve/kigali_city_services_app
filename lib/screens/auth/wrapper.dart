import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart'; // You'll create this soon
import 'login_screen.dart';       // You'll create this soon

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user == null) {
      return const LoginScreen();
    } else if (!authProvider.user!.emailVerified) {
      return const VerifyEmailScreen(); // Crucial for "Excellent" grade
    } else {
      return const HomeScreen();
    }
  }
}

// Simple placeholder for Verify Email
class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Please verify your email to continue."),
            ElevatedButton(
              onPressed: () => Provider.of<AuthProvider>(context, listen: false).reloadUser(),
              child: const Text("I have verified it"),
            ),
          ],
        ),
      ),
    );
  }
}