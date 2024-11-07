import 'package:ashton_tennis_unity/screens/login/login.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
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
    logger.i("Firebase App Failed: ${e.toString()}");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        home: const LoginPage());
  }
}
