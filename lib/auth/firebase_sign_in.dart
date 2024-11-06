import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user; // Returns the user if sign-in is successful
    } catch (e) {
      print('Error signing in: $e');
      return null; // Returns null if there's an error
    }
  }
}

//Function to handle user signin
Future<User?> handleSignIn({
  required TextEditingController emailController,
  required TextEditingController passWordController,
  required FirebaseAuthService instance_,
  required BuildContext context,
}) async {
  final email = emailController.text.trim();
  final password = passWordController.text.trim();

  // Attempt to sign in
  final user = await instance_.signInWithEmailAndPassword(email, password);

  if (user != null) {
    // Clear the controllers if sign-in is successful
    emailController.clear();
    passWordController.clear();

    // Return the user to indicate a successful login
    return user;
  } else {
    // Show error message if sign-in fails
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid email or password')),
    );

    // Return null to indicate a failed login
    return null;
  }
}