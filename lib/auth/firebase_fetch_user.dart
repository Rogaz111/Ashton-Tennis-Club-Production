import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

Future<Map<String, dynamic>?> fetchUserDetails(String uid) async {
  try {
    // Query Firestore for the user document
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection(
            'users') // Replace 'users' with your Firestore collection name
        .doc(uid) // Use the uid to fetch the document
        .get();

    if (userDoc.exists) {
      logger.w(userDoc.data() as Map<String, dynamic>);
      // Return the entire document data as a map
      return userDoc.data() as Map<String, dynamic>;
    } else {
      logger.i('User document does not exist');
      return null; // Return null if the document doesn't exist
    }
  } catch (e) {
    // Handle errors
    logger.e('Error fetching profile: $e');
    return null; // Return null in case of an error
  }
}
