// Fetch all members from committee_members collection - READ ALL
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
final FirebaseStorage _storage = FirebaseStorage.instance;

// Fetch Member Birthdays from firestore - READ ALL
Future<List<Map<String, dynamic>>> fetchBirthdays() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('member_birthdays').get();
  return snapshot.docs.map((doc) {
    return {
      'docId': doc.id, // Include the document ID
      ...doc.data(), // Spread the document fields
    };
  }).toList();
}

// Add member to committee_members collection - CREATE
Future<void> addBirthday(Map<String, dynamic> birthdayData) async {
  try {
    await FirebaseFirestore.instance
        .collection('member_birthdays')
        .add(birthdayData);
    logger.i('Member birthday added to member_birthdays collection.');
  } catch (e) {
    logger.w(
        'Failed to add member birthday to member_birthdays collection. Error: $e');
  }
}

// Upload member image to Firebase Storage and return the download URL
Future<String?> uploadBirthdayImage(File image, String uid) async {
  try {
    // Set up the reference to the profile_images directory in Firebase Storage
    final storageRef = _storage.ref().child('member_birthdays/$uid');
    // Upload the file
    await storageRef.putFile(image);
    // Get and return the download URL
    return await storageRef.getDownloadURL();
  } catch (e) {
    logger.w('Error member image: $e');
    return null;
  }
}
