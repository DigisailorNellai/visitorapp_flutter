import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefence {
  saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  saveUserEmail(String email) {}
}
