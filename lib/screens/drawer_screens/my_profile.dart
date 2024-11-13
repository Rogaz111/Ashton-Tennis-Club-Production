import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../auth/firebase_fetch_user.dart';
import '../../auth/firebase_storage.dart';
import '../../auth/firebase_update_user.dart';
import '../forget_password/forget_password_unauth.dart';
import 'helper_widgets.dart';

class MyProfile extends StatefulWidget {
  final String uid; // Accept uid as a required parameter
  const MyProfile({super.key, required this.uid});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>
    with SingleTickerProviderStateMixin {
  late String uid; // Variable to hold the UID
  Map<String, dynamic>? userObject;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController rankController = TextEditingController();
  final Logger logger = Logger();
  final ImagePicker picker = ImagePicker();
  File? image;

  late AnimationController _controller;

  bool isReadOnly = true;
  bool fetchingData = true;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Full animation cycle
    )..repeat(); // Loop the animation

    _initializeUserData();
  }

  @override
  void dispose() {
    // Dispose AnimationController
    _controller.dispose();
    super.dispose();
  }

  // Load Firestore Collection Metadata function
  Future<void> _initializeUserData() async {
    try {
      // Fetch user details from Firebase
      userObject = await fetchUserDetails(uid);

      if (userObject != null) {
        // Populate the controllers with fetched data
        setState(() {
          imageUrl = userObject!['profileImageUrl'] ??
              'https://img.freepik.com/free-psd/3d-illustration-with-online-avatar_23-2151303097.jpg';
          usernameController.text = userObject!['username'] ?? 'N/A';
          emailController.text = userObject!['email'] ?? 'N/A';
          phoneController.text = userObject!['phone'] ?? 'N/A';
          ageController.text = userObject!['age'].toString();

          fetchingData = false; // Stop loading
        });
      } else {
        logger.e('Failed to fetch user details');
      }
    } catch (e) {
      logger.e(e);
      setState(() {
        fetchingData = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'My Profile'),
      body: fetchingData
          ? buildLoadingIndicatorProfile() // Show loading animation
          : Stack(
              children: [
                // Curved background
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(50),
                      ),
                    ),
                  ),
                ),

                // Main Content (Profile)
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture with edit icon
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: image != null
                                ? FileImage(image!) as ImageProvider
                                : NetworkImage(imageUrl ?? ''),
                            backgroundColor: Colors.grey[200],
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () => pickImage(
                                picker: picker,
                                onImagePicked: (File pickedImage) {
                                  setState(() {
                                    image = pickedImage;
                                  });
                                },
                              ),
                              child: isReadOnly
                                  ? Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: const Icon(Icons.camera_alt,
                                          color: Colors.indigo),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildNeumorphicActionButton(
                            context,
                            label: isReadOnly ? "Edit Profile" : "Cancel",
                            onPressed: () {
                              setState(() {
                                isReadOnly =
                                    !isReadOnly; // Toggle editing state
                              });
                            },
                          ),
                          buildNeumorphicActionButton(
                            context,
                            label: "Reset Password",
                            onPressed: () {
                              showForgotPasswordDialog(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // User Details Section
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              buildFieldProfile(context,
                                  label: 'Username',
                                  usernameController: usernameController,
                                  readOnly: isReadOnly,
                                  inputType: TextInputType.text,
                                  icon: Icons.person),
                              const SizedBox(height: 15),
                              buildFieldProfile(context,
                                  label: 'Email',
                                  usernameController: emailController,
                                  readOnly: true,
                                  inputType: TextInputType.emailAddress,
                                  icon: Icons.email),
                              const SizedBox(height: 15),
                              buildFieldProfile(context,
                                  label: 'Phone',
                                  usernameController: phoneController,
                                  readOnly: isReadOnly,
                                  inputType: TextInputType.phone,
                                  icon: Icons.phone),
                              const SizedBox(height: 15),
                              buildFieldProfile(context,
                                  label: 'Age',
                                  usernameController: ageController,
                                  readOnly: isReadOnly,
                                  inputType: TextInputType.number,
                                  icon: Icons.calendar_today),
                              const SizedBox(height: 15),
                              buildFieldProfile(context,
                                  label: 'Current Rank',
                                  usernameController: rankController,
                                  readOnly: true,
                                  inputType: TextInputType.number,
                                  icon: Icons.star),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: isReadOnly
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> newValues = {
                    if (usernameController.text.isNotEmpty)
                      'username': usernameController.text,
                    if (phoneController.text.isNotEmpty)
                      'phone': phoneController.text,
                    if (ageController.text.isNotEmpty)
                      'age': int.tryParse(ageController.text) ?? 0,
                  };

                  // If an image is selected, upload it and get the new URL
                  if (image != null) {
                    final newImageUrl = await uploadProfileImage(image!, uid);
                    if (newImageUrl != null) {
                      newValues['profileImageUrl'] = newImageUrl;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to upload profile image')),
                      );
                      return;
                    }
                  }

                  // Update user collection
                  bool isSuccess = await updateUserDetails(uid, newValues);

                  if (isSuccess) {
                    setState(() {
                      isReadOnly = true;
                      if (newValues.containsKey('profileImageUrl')) {
                        imageUrl = newValues['profileImageUrl'];
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Profile updated successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update profile')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
    );
  }

  // Custom Loading Indicator Widget
  Widget buildLoadingIndicatorProfile() {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double angle = _controller.value * 2 * pi; // Full rotation
            double radius = 20; // Distance between balls

            // Calculate positions for two animated balls
            Offset ball1Offset = Offset(
              radius * cos(angle),
              radius * sin(angle),
            );
            Offset ball2Offset = Offset(
              radius * -cos(angle),
              radius * -sin(angle),
            );

            return Stack(
              alignment: Alignment.center,
              children: [
                // Ball 1
                Transform.translate(
                  offset: ball1Offset,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                ),

                // Ball 2
                Transform.translate(
                  offset: ball2Offset,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
