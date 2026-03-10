import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthProvider() {
    // Listen to auth changes (login/logout)
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // SIGN UP
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Requirement: Send verification email
      await result.user?.sendEmailVerification();
      return null; // Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // LOG IN
  Future<String?> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // LOG OUT
  Future<void> logOut() async {
    await _auth.signOut();
  }

  // If user verified 
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      _user = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      print('Error reloading user: $e');
    }
  }
}
