import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/firebase_options.dart';
import 'package:visitor_app_flutter/pages/signin.dart';
import 'package:visitor_app_flutter/pages/visitor_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/Signin',
      getPages: [
        GetPage(name: '/Signin', page: () => SignInScreen()),
        GetPage(name: '/Visitorpage', page: () => Visitorpage()),
      ],
    );
  }
}
