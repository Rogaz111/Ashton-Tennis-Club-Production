// ignore_for_file: prefer_final_fields
import 'dart:math';
import 'package:ashton_tennis_unity/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ashton_tennis_unity/login/login_widgets.dart';
import '../constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  // username and password field controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  late AnimationController _controller;

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
    _controller.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(

              padding: const EdgeInsets.symmetric(horizontal: 24.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Club Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage('assets/images/login_logo.png')
                      ),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400]!,
                          offset: const Offset(10, 10),
                          blurRadius: 15,
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          offset: Offset(-10, -10),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Welcome Text
                  Center(
                    child: Text(
                      'Welcome Back!',
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
                      'Please login to continue',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Username Field with Neumorphism
                  buildTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),

                  // Password Field with Neumorphism
                  buildTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),

                  // Login Button with Neumorphism
                  Container(
                    decoration: neumorphicBoxDecoration(),
                    child: ElevatedButton(
                      onPressed: () async {

                        if(usernameController.text.isNotEmpty || passwordController.text.isNotEmpty){
                            setState(() {
                              isLoading = true;
                            });

                            await Future.delayed(const Duration(seconds: 2));
                            usernameController.clear();
                            passwordController.clear();

                            setState(() {
                              isLoading = false;
                            });
                          }else{
                          try{
                            print(snackBarErrorMessage.toString());
                            showNeumorphicSnackbar(context, snackBarErrorMessage);
                          }catch(e){
                            print(e.toString());
                          }

                          }
                        },

                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.grey[200],
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ?  buildLoadingIndicator()
                          : Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign-Up Button with Neumorphism
                  Container(
                    decoration: neumorphicBoxDecoration(),
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.grey[200],
                        side: const BorderSide(color: Colors.transparent),
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Forgot Password Option
                  Center(
                    child: TextButton(
                      onPressed: () {

                      },
                      child: Text(
                        'Forgot Password?',
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
        ],
      ),
    );
  }
  // Custom Loading Indicator Widget
  Widget buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double angle = _controller.value * 6.3; // Full rotation in radians (360 degrees)

        // Calculate offsets for two balls
        double radius = 20; // Adjust as needed for spacing
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

// Helper method to create a Neumorphic-styled ball
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
            offset:  const Offset(3, 3),
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