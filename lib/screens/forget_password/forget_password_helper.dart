// Send Password Reset Email
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    Navigator.of(context).pop(); // Close the dialog on success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password reset email sent to $email')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
