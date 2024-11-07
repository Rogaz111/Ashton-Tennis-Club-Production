class AppUser {
  final String uid;
  final String username;
  final String email;
  final String phone;
  final String? role;
  final int age;
  final String? profileImageUrl;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
    required this.age,
    this.role,
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
      'role': role,
      'profileImageUrl': profileImageUrl,
    };
  }
}
