class CommiteeMember {
  final String name;
  final String role;
  final String phone;
  final String? memberImageUrl;

  CommiteeMember(
      {required this.name,
      required this.role,
      required this.phone,
      this.memberImageUrl});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'phone': phone,
      'memberImageUrl': memberImageUrl,
    };
  }
}
