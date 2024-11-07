import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/firebase_forgot_password.dart';

void showForgotPasswordDialog(BuildContext context) {
  final emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.grey[200], // Neumorphic background color
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Forgot Password',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),

              // Instructions
              Text(
                'Enter your email address to receive a password reset link.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Email Input Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400]!,
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your email',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Actions Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Reset Password Button
                  ElevatedButton(
                    onPressed: () async {
                      final email = emailController.text.trim();
                      if (email.isNotEmpty) {
                        await sendPasswordResetEmail(email, context);
                        await Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[400],
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.indigo[200],
                    ),
                    child: Text(
                      'Reset Password',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
