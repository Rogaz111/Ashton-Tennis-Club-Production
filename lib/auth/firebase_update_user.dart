import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
bool success = false;

Future<bool> updateUserDetails(
    String uid, Map<String, dynamic> updatedData) async {
  try {
    // Reference to the Firestore document
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(uid);

    // Update the user's details
    await userDoc.update(updatedData);

    logger.i("User details updated successfully");
    return true; // Return true if the update is successful
  } catch (e) {
    logger.w("Error updating user details: $e");
    return false; // Return false if there's an error
  }
}
