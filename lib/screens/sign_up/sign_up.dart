import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../auth/firebase_sign_up.dart';
import '../../auth/firebase_storage.dart';
import 'sign_up_widgets.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Global key for form validation
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  File? image;
  final ImagePicker picker = ImagePicker();
  late AnimationController _controller;
  bool isLoading = false;
  bool isSnackbarVisible = false; // Track Snackbar visibility

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Keep rotating
  }

  @override
  void dispose() {
    _controller.dispose(); // Ensure controller is disposed
    usernameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Join Our Club!',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Fill in the details to get started',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Profile Picture Upload
                Center(
                  child: GestureDetector(
                    onTap: () => pickImage(
                      picker: picker,
                      onImagePicked: (File pickedImage) {
                        setState(() {
                          image = pickedImage;
                        });
                      },
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: image != null ? FileImage(image!) : null,
                      child: image == null
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.grey[700],
                              size: 30,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Form Fields with Validation
                buildTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    } else if (value.length < 10) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: ageController,
                  hintText: 'Age',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Age is required';
                    } else if (int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return 'Enter a valid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Sign-Up Button with Validation Check
                Container(
                  decoration: neumorphicBoxDecoration(),
                  child: ElevatedButton(
                    onPressed: () async {
                      String? errorCode = validateForm();
                      switch (errorCode) {
                        case 'username_empty':
                          showNeumorphicSnackbar(
                              context, 'Username is required');
                          break;
                        case 'phone_empty':
                          showNeumorphicSnackbar(
                              context, 'Phone number is required');
                          break;
                        case 'email_empty':
                          showNeumorphicSnackbar(context, 'Email is required');
                          break;
                        case 'email_invalid':
                          showNeumorphicSnackbar(
                              context, 'Enter a valid email');
                          break;
                        case 'age_empty':
                          showNeumorphicSnackbar(context, 'Age is required');
                          break;
                        case 'age_invalid':
                          showNeumorphicSnackbar(context, 'Enter a valid age');
                          break;
                        case 'password_empty':
                          showNeumorphicSnackbar(
                              context, 'Password is required');
                          break;
                        case 'password_short':
                          showNeumorphicSnackbar(context,
                              'Password must be at least 6 characters');
                          break;
                        default:
                          // No validation errors, proceed with sign-up logic
                          setState(() {
                            isLoading = true;
                          });

                          final user =
                              await _authService.signUpWithEmailAndPassword(
                            auth: _auth,
                            email: emailController.text,
                            password: passwordController.text,
                            username: usernameController.text,
                            phone: phoneController.text,
                            age: int.parse(ageController.text.trim()),
                            role: 'member',
                            profileImageUrl: null, // Temporary null
                          );

                          if (user != null) {
                            String? profileImageUrl;
                            //If an image is selected, upload it
                            if (image != null) {
                              profileImageUrl =
                                  await uploadProfileImage(image!, user.uid);
                            }

                            //Update Firestore with the image URL if available
                            if (profileImageUrl != null) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({'profileImageUrl': profileImageUrl});
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Sign-up successful!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Sign-up failed. Please try again.')),
                            );
                          }

                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? buildLoadingIndicator()
                        : Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.indigo,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Validation Helper Function
  String? validateForm() {
    if (usernameController.text.isEmpty) return 'username_empty';
    if (phoneController.text.isEmpty) return 'phone_empty';
    if (emailController.text.isEmpty) return 'email_empty';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      return 'email_invalid';
    }
    if (ageController.text.isEmpty) return 'age_empty';
    if (int.tryParse(ageController.text) == null ||
        int.parse(ageController.text) <= 0) return 'age_invalid';
    if (passwordController.text.isEmpty) return 'password_empty';
    if (passwordController.text.length < 6) return 'password_short';
    return null; // No errors, form is valid
  }

  Widget buildLoadingIndicator() {
    // Check if _controller is initialized
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double angle = _controller.value * 6.3; // Full rotation in radians

        // Calculate offsets for two balls
        double radius = 20;
        Offset ball1Offset = Offset(
          radius * -sin(angle),
          radius * cos(angle),
        );
        Offset ball2Offset = Offset(
          radius * sin(angle),
          radius * -cos(angle),
        );

        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: ball1Offset,
              child: _buildNeumorphicCircle(Colors.green),
            ),
            Transform.translate(
              offset: ball2Offset,
              child: _buildNeumorphicCircle(Colors.yellow),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNeumorphicCircle(Color color) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-3, -3),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}
