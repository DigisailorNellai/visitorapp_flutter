import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:visitor_app_flutter/pages/signin.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOutAndNavigateToSignIn() async {
    await _auth.signOut();
    Get.offAll(() =>
        SignInScreen()); // Navigate to SignInScreen and remove all previous screens
  }
}
