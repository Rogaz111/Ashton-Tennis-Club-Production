import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../screens/login/login.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onDone;

  const OnboardingScreen({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.grey[200], // Neumorphic background color
      pages: [
        PageViewModel(
          title: "Welcome to the Ashton Community Tennis Club",
          body: "Discover all the amazing features we have to offer.",
          image: Center(
            child: neumorphicImage('assets/images/animated_logo.gif'),
          ),
          decoration: neumorphicPageDecoration(),
        ),
        PageViewModel(
          title: "Let's take a tour through the app",
          body: "First, create your account by clicking on the sign-up button.",
          image: Center(
            child: neumorphicImage('assets/images/landing_screen.png'),
          ),
          decoration: neumorphicPageDecoration(),
        ),
        PageViewModel(
          title: "Upload your picture and complete the sign up details.",
          body:
              "Complete the sign up details. Remember, never share your password with anyone. Some fields may be required so fill them in where required.",
          image: Center(
            child: neumorphicImage('assets/images/sign_up_screen.png'),
          ),
          decoration: neumorphicPageDecoration(),
        ),
        PageViewModel(
          title: "Great! We're signed up! Now let's login.",
          body:
              "After signing up, use your Email and Password and click login.",
          image: Center(
            child: neumorphicImage('assets/images/login_click.png'),
          ),
          decoration: neumorphicPageDecoration(),
        ),
        PageViewModel(
          title: "Welcome Home!.",
          body:
              "The home screen should display your unique username upon successful login.",
          image: Center(
            child: neumorphicImage('assets/images/home_screen.png'),
          ),
          decoration: neumorphicPageDecoration(),
        ),
        PageViewModel(
          title: "Open the drawer!",
          body:
              "On the home screen, click on the drawer at the top left of the screen and you should see all the features and account settings you can use in the app."
              "The drawer should display your uploaded picture, username and email address.",
          image: Center(
            child: neumorphicImage('assets/images/drawer_showcase.png'),
          ),
          decoration: neumorphicPageDecoration(),
        ),
        PageViewModel(
          title: "Try checking your profile!",
          body:
              "Click on the My Profile option to view or amend any of your personal information.",
          image: Center(
            child: neumorphicImage('assets/images/my_profile_screen.png'),
          ),
          decoration: neumorphicPageDecoration(),
        ),
        PageViewModel(
          title: "In need of assistance?",
          body:
              "Click the Contact Us option to view contact information of all committee members at the club for any of your urgent concerns or questions.",
          image: Center(
            child: neumorphicImage('assets/images/contact_us_screen.png'),
          ),
          decoration: neumorphicPageDecoration(),
        ),
      ],
      onDone: onDone,
      onSkip: onDone,
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      skipOrBackFlex: 1, // Allocate less space for the "Skip" button
      dotsFlex: 2, // Allocate moderate space for the dots indicator
      nextFlex: 1, // Allocate less space for the "Next" button
      dotsDecorator: DotsDecorator(
        size: const Size(6.0, 6.0), // Smaller dots
        activeSize: const Size(16.0, 6.0), // Active dot is slightly larger
        activeColor: Colors.indigo,
        color: Colors.grey,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  // Helper method to create a neumorphic image
  Widget neumorphicImage(String assetPath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
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
      ),
      padding: const EdgeInsets.all(16),
      child: Image.asset(assetPath, height: 200.0), // Larger image height
    );
  }

  // Helper method to create neumorphic page decoration
  PageDecoration neumorphicPageDecoration() {
    return PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyTextStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.black54,
        height: 1.5,
      ),
      imagePadding: const EdgeInsets.all(16.0),
      pageColor: Colors.grey[200], // Background color
    );
  }
}
