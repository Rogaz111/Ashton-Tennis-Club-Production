import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';

class FirebaseAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();

  // Sign up with email and password, and store additional user details in Firestore
  Future<User?> signUpWithEmailAndPassword({
    required FirebaseAuth auth,
    required String email,
    required String password,
    required String username,
    required String phone,
    required int age,
    String? role,
    String? profileImageUrl,
  }) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create AppUser object with user info
      AppUser newUser = AppUser(
        uid: userCredential.user!.uid,
        username: username,
        email: email,
        phone: phone,
        age: age,
        role: 'member',
        profileImageUrl: profileImageUrl,
      );

      // Save user info to Firestore
      await _firestore
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());
      return userCredential.user;
    } catch (e) {
      logger.e('Error signing up: $e');
      return null;
    }
  }
}
