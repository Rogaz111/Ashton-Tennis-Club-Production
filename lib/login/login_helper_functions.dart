// Fetches user data from Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> fetchUserData(String uid) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (doc.exists) {
    return doc.data() ?? {}; // Return user data as a map
  } else {
    throw Exception("User data not found");
  }
}