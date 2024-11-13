import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
final FirebaseStorage _storage = FirebaseStorage.instance;
String? profileImageUrl;

// Add member to committee_members collection - CREATE
Future<void> addCommitteeMember(Map<String, dynamic> memberData) async {
  try {
    await FirebaseFirestore.instance
        .collection('committee_members')
        .add(memberData);
    logger.i('Member added to committee_members collection.');
  } catch (e) {
    logger.w('Failed to add to committee_members collection. Error: $e');
  }
}

// Fetch all members from committee_members collection - READ ALL
Future<List<Map<String, dynamic>>> fetchCommitteeMembers() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('committee_members').get();
  return snapshot.docs.map((doc) {
    return {
      'docId': doc.id, // Include the document ID
      ...doc.data(), // Spread the document fields
    };
  }).toList();
}

// Edit member to committee_members collection - UPDATE -- Currently not in use
Future<void> editCommitteeMember(
    String docId, Map<String, dynamic> updatedData) async {
  await FirebaseFirestore.instance
      .collection('committee_members')
      .doc(docId)
      .update(updatedData);
}

// Delete member from committee_members collection - DELETE
Future<void> deleteCommitteeMember(String docId) async {
  try {
    await FirebaseFirestore.instance
        .collection('committee_members')
        .doc(docId)
        .delete();
    logger.i('Member deleted from committee_members collection.');
  } catch (e) {
    logger.w(
        'Member failed to delete from committee_members collection. Error: $e');
  }
}

// Upload member image to Firebase Storage and return the download URL
Future<String?> uploadMemberImage(File image, String uid) async {
  try {
    // Set up the reference to the profile_images directory in Firebase Storage
    final storageRef = _storage.ref().child('member_images/$uid');
    // Upload the file
    await storageRef.putFile(image);
    // Get and return the download URL
    return await storageRef.getDownloadURL();
  } catch (e) {
    logger.w('Error member image: $e');
    return null;
  }
}
