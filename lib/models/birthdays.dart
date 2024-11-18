import 'package:cloud_firestore/cloud_firestore.dart';

class Birthday {
  String name;
  DateTime date;
  String? birthdayImageUrl;

  Birthday({
    required this.name,
    required this.date,
    this.birthdayImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date':
          Timestamp.fromDate(date), // Convert DateTime to Firestore Timestamp
      'birthdayImageUrl': birthdayImageUrl,
    };
  }

  factory Birthday.fromMap(Map<String, dynamic> map) {
    return Birthday(
      name: map['name'],
      date: (map['date'] as Timestamp)
          .toDate(), // Convert Firestore Timestamp to DateTime
      birthdayImageUrl: map['birthdayImageUrl'],
    );
  }
}
