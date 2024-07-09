import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String name;
  final String phone;
  final String email;
  final String role;
  final String department;

  Profile({
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.department,
  });

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Profile(
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      department: data['department'] ?? '',
    );
  }
}
