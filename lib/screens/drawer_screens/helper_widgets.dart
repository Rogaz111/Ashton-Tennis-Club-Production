import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// My Profile screen appBar widget
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      'My Profile',
      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
    ),
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ),
  );
}

// Used in My Profile Screen For Edit Profile and Reset Password Buttons
Widget buildNeumorphicActionButton(BuildContext context,
    {required String label, required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          // Light shadow
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(-3, -3),
            blurRadius: 5,
          ),
          // Dark shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(3, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    ),
  );
}

// Used in My Profile Screen for Meta data fields display
Widget buildFieldProfile(BuildContext context,
    {required String label,
    required TextEditingController usernameController,
    required bool readOnly,
    required TextInputType inputType,
    required IconData icon}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Label with Fixed Width
      SizedBox(
        width: 100, // Adjust the width as needed for consistency
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ),

      const SizedBox(width: 8), // Spacing between label and TextField

      // TextField
      Expanded(
        child: TextField(
          controller: usernameController,
          keyboardType: inputType,
          style: GoogleFonts.poppins(color: Colors.grey[800]),
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly
                ? Colors.grey[200]
                : const Color(0xFFBBDEFB), // Light Blue
            hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
            prefixIcon: Icon(icon, color: Colors.indigo),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    ],
  );
}

//Image Picker Function My Profile Image Editing
// Function to pick an image
Future<void> pickImage({
  required ImagePicker picker,
  required void Function(File) onImagePicked,
}) async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    onImagePicked(
        File(pickedFile.path)); // Calls the callback with the selected image
  }
}
