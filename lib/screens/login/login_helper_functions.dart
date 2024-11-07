// Fetches user data from Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> fetchUserData(String username) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(username).get();
  if (doc.exists) {
    return doc.data() ?? {}; // Return user data as a map
  } else {
    return {};
  }
}
