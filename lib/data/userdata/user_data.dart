import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:visitor_app_flutter/models/profile_model/profile_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Profile> getUserProfile(String userId) async {
    var doc = await _db.collection('users').doc(userId).get();
    return Profile.fromFirestore(doc);
  }
}
