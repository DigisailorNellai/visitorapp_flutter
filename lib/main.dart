// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:visitor_app_flutter/firebase_options.dart';
// import 'package:visitor_app_flutter/pages/main_page.dart';
// import 'package:visitor_app_flutter/pages/signin.dart';
// import 'package:visitor_app_flutter/pages/user_information.dart';
// import 'package:visitor_app_flutter/pages/visitor_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   // FirebaseAuth.instance.authStateChanges().listen((User? user) {
//   //   if (user == null) {
//   //     print('No user is currently logged in.');
//   //   } else {
//   //     print('User is logged in: ${user.uid}');
//   //   }
//   // });
//   await signInWithEmailPassword();
//   runApp(const MyApp());
// }
// Future<void> signInWithEmailPassword() async {
//   try {
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: 'abdulkatherdgl@gmail.com', // Replace with your test user's email
//       password: 'kather', // Replace with your test user's password
//     );
//     print('Signed in as: ${userCredential.user?.uid}');
//   } catch (e) {
//     print('Error signing in: $e');
//   }
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/Signin',
//       getPages: [
//         GetPage(name: '/Signin', page: () => SignInScreen()),
//         GetPage(name: '/Mainpage', page: () => Mainpage()),
//         GetPage(name: '/Visitorpage', page: () => Visitorpage()),
//         GetPage(name: '/UserInformation', page: () => UserInformation()),
//       ],
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/firebase_options.dart';
import 'package:visitor_app_flutter/pages/main_page.dart';
import 'package:visitor_app_flutter/pages/signin.dart';
import 'package:visitor_app_flutter/pages/user_information.dart';
import 'package:visitor_app_flutter/pages/visitor_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const AuthCheckPage()),
        GetPage(name: '/Signin', page: () => SignInScreen()),
        GetPage(name: '/Mainpage', page: () => Mainpage()),
        GetPage(name: '/Visitorpage', page: () => const Visitorpage()),
        GetPage(name: '/UserInformation', page: () => UserInformation()),
      ],
    );
  }
}

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return Mainpage(); // User is logged in, show main page
        } else {
          return SignInScreen(); // User is not logged in, show sign-in screen
        }
      },
    );
  }
}
