import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

// Neumorphic-style Button
Widget buildActionButton(BuildContext context,
    {required String label, required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      shadowColor: Colors.grey[400],
      elevation: 5,
    ),
    child: Text(
      label,
      style: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    ),
  );
}

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
            fillColor: readOnly ? Colors.grey[200] : Colors.blueAccent[200],
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
