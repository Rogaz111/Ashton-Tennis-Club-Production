import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    logger.i('Password reset email sent to $email.');
  } catch (e) {
    logger.w('Failed to send password reset email: $e');
  }
}
