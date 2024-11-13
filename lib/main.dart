import 'package:ashton_tennis_unity/screens/login/login.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/onboarding_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'constants/constants.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Logger
  final Logger logger = Logger();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.i("Firebase initialized successfully");

  try {
    // Initialize Firebase App Check
    await FirebaseAppCheck.instance.activate(
        androidProvider:
            AndroidProvider.playIntegrity // Use Play Integrity for Android
        );
    logger.i("Firebase App Check activated");
  } catch (e) {
    logger.i("Firebase App Failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Check if onboarding has been completed
  Future<bool> hasSeenOnboarding() async {
    logger.i('Fetching Shared Pref value.');
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_seen') ?? false; // Default to false
  }

  // Set onboarding as completed
  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    logger.i('Shared Pref bool value set');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: hasSeenOnboarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data == false) {
            // Show onboarding if not seen
            return OnboardingScreen(
              onDone: () async {
                await setOnboardingSeen();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            );
          }

          // Show login page if onboarding has been seen
          return const LoginPage();
        },
      ),
    );
  }
}
