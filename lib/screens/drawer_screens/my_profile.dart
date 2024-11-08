import 'package:ashton_tennis_unity/screens/drawer_screens/helper_widgets.dart';
import 'package:flutter/material.dart';

import '../forget_password/forget_password_unauth.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController usernameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController emailController =
      TextEditingController(text: 'jd@email.co.za');
  final TextEditingController phoneController =
      TextEditingController(text: '0662291603');
  final TextEditingController ageController = TextEditingController(text: '25');
  final TextEditingController rankController = TextEditingController(text: '7');

  bool isReadOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: const NetworkImage(
                      'https://i.pinimg.com/564x/d7/1d/5c/d71d5cce025b22cea3b3ef9a48f9fd4a.jpg'),
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildActionButton(
                  context,
                  label: isReadOnly ? "Edit Profile" : "Cancel",
                  onPressed: () {
                    setState(() {
                      isReadOnly = !isReadOnly; // Toggle editing state
                    });
                  },
                ),
                buildActionButton(
                  context,
                  label: "Reset Password",
                  onPressed: () {
                    // Implement Reset Password action
                    showForgotPasswordDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
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
                readOnly: isReadOnly,
                inputType: TextInputType.emailAddress,
                icon: Icons.email),
            const SizedBox(height: 15),
            buildFieldProfile(context,
                label: 'Phone',
                usernameController: phoneController,
                readOnly: isReadOnly,
                inputType: TextInputType.number,
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
                readOnly: isReadOnly,
                inputType: TextInputType.number,
                icon: Icons.star),
          ],
        ),
      ),
      bottomNavigationBar: isReadOnly
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isReadOnly = true; // Save changes and exit editing mode
                  });
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
}
