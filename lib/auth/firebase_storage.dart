import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

String? profileImageUrl;
final FirebaseStorage _storage = FirebaseStorage.instance;

// Upload profile image to Firebase Storage and return the download URL
Future<String?> uploadProfileImage(File image, String uid) async {
  try {
    // Set up the reference to the profile_images directory in Firebase Storage
    final storageRef = _storage.ref().child('profile_images/$uid');
    // Upload the file
    await storageRef.putFile(image);
    // Get and return the download URL
    return await storageRef.getDownloadURL();
  } catch (e) {
    print('Error uploading profile image: $e');
    return null;
  }
}