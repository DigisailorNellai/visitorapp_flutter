import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<Map<String, dynamic>?> getUserDetails(String userId) async {
  //   // User? user = _auth.currentUser;
  //   // print('Current user: ${user?.uid}');
  //   DocumentSnapshot<Map<String, dynamic>> snapshot =
  //       await _firestore.collection('visitors').doc(userId).get();
  //   return snapshot.data();
  // }

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('visitors').doc(userId).get();
    return snapshot.data();
  }
}
