import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// Custom TextField Widget
Widget buildTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  String? Function(String?)? validator, // Add validator parameter
}) {
  return Container(
    decoration: neumorphicBoxDecoration(),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.grey[800]),
      validator: validator, // Apply the validator here
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

// Neumorphic Box Decoration
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

// Function to pick an image
Future<void> pickImage({
  required ImagePicker picker,
  required void Function(File) onImagePicked,
}) async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    onImagePicked(File(pickedFile.path)); // Calls the callback with the selected image
  }
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
