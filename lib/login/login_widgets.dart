// Custom TextField Widget with Neumorphism
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Widget handles Login Screen Text fields, Login and Password
Widget buildTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  bool obscureText = false,
}) {
  return Container(
    decoration: neumorphicBoxDecoration(),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.poppins(color: Colors.grey[800]),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.indigo),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

//Neumorphic Box Decoration for consistency
BoxDecoration neumorphicBoxDecoration() {
  return BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey[400]!,
        offset: const Offset(6, 6),
        blurRadius: 12,
      ),
      const BoxShadow(
        color: Colors.white,
        offset: Offset(-6, -6),
        blurRadius: 12,
      ),
    ],
  );
}

// Snackbar Widget
void showNeumorphicSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Container(
      padding: const EdgeInsets.all(16),
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
      child: Text(
        message,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.grey[800],
        ),
      ),
    ),
    backgroundColor: Colors.grey[200]!.withOpacity(0.9), // Use semi-transparency
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
  );

  // Show the Snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}