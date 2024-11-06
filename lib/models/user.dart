class AppUser {
  final String uid;
  final String username;
  final String email;
  final String phone;
  final int age;
  final String? profileImageUrl;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
    required this.age,
    this.profileImageUrl,
  });

  // Convert AppUser to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phone': phone,
      'age': age,
      'profileImageUrl': profileImageUrl,
    };
  }

  // Optional: Initialize an AppUser from Firestore data
  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      age: data['age'] ?? 0,
      profileImageUrl: data['profileImageUrl'],
    );
  }
}