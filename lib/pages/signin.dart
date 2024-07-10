// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:visitor_app_flutter/functions/shared_prefence.dart';
// import 'package:visitor_app_flutter/pages/forget_password.dart';
// import 'package:visitor_app_flutter/pages/main_page.dart';
// import 'package:visitor_app_flutter/pages/security_page.dart';
// import 'package:visitor_app_flutter/pages/staff_home_page.dart';
// import 'package:visitor_app_flutter/pages/visitor_page.dart';

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// final SharedPrefence cookies = SharedPrefence();

// class _SignInScreenState extends State<SignInScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late String _email, _password;
//   bool _isLoading = false;
//   bool _isPasswordVisible = false;

//   void _togglePasswordVisibility() {
//     setState(() {
//       _isPasswordVisible = !_isPasswordVisible;
//     });
//   }

//   Future<void> _signIn() async {
//     final formState = _formKey.currentState;
//     if (formState == null) return;

//     if (formState.validate()) {
//       formState.save();
//       if (!mounted) return;

//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _email,
//           password: _password,
//         );

//         String uid = userCredential.user!.uid;
//         print("User signed in with UID: $uid");

//         // Check if the email exists in the "staffs" collection
//         QuerySnapshot staffSnapshot = await FirebaseFirestore.instance
//             .collection('staffs')
//             .where('email', isEqualTo: _email)
//             .limit(1)
//             .get();
        
//         if (staffSnapshot.docs.isNotEmpty) {
//           // Staff found
//           print("Staff document found. Navigating to StaffHomePage");
//           await cookies.saveUserId(uid);
//           if (!mounted) return;
//           Get.offAll(() => Staff_Home_Page());
//           return;
//         }

//         // Check if the email exists in the "visitors" collection
//         QuerySnapshot visitorSnapshot = await FirebaseFirestore.instance
//             .collection('visitors')
//             .where('email', isEqualTo: _email)
//             .limit(1)
//             .get();

//         if (visitorSnapshot.docs.isNotEmpty) {
//           // Visitor found
//           print("Visitor document found. Navigating to VisitorHomePage");
//           await cookies.saveUserId(uid);
//           if (!mounted) return;
//           Get.offAll(() => Mainpage());
//           return;
//         }

//         // If the email is not found in both collections
//         throw FirebaseAuthException(code: 'user-not-found', message: 'No user found with this email.');

//       } catch (e) {
//         print("Error during sign-in: $e");
//         String message = "Failed to sign in. Please try again.";
//         if (e is FirebaseAuthException) {
//           switch (e.code) {
//             case 'user-not-found':
//               message = "No user found with this email.";
//               break;
//             case 'wrong-password':
//               message = "Incorrect password. Please try again.";
//               break;
//             case 'invalid-email':
//               message = "The email address is not valid.";
//               break;
//             case 'network-request-failed':
//               message = "Network request failed. Please check your internet connection.";
//               break;
//             default:
//               message = "An error occurred: ${e.message}";
//           }
//         } else {
//           message = "An unexpected error occurred.";
//         }
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(message),
//             ),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const SizedBox(height: 50),
//               Image.asset('assets/logo.png'),
//               const SizedBox(height: 150),
//               Center(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Email',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) => _email = value!,
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Password',
//                           suffixIcon: IconButton(
//                             onPressed: _togglePasswordVisibility,
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         obscureText: !_isPasswordVisible,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) => _password = value!,
//                       ),
//                       const SizedBox(height: 20),
//                       _isLoading
//                           ? const CircularProgressIndicator()
//                           : ElevatedButton(
//                               onPressed: _signIn,
//                               style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all<Color>(
//                                     const Color.fromARGB(255, 19, 62, 97)),
//                                 shape: MaterialStateProperty.all<OutlinedBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                   ),
//                                 ),
//                                 minimumSize: MaterialStateProperty.all<Size>(
//                                   const Size(double.infinity, 50),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Sign In',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                       const SizedBox(height: 20),
//                       TextButton(
//                         onPressed: () {
//                           Get.to(() => const ForgetPassword());
//                         },
//                         child: const Text(
//                           'Forgot Password?',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           Get.to(() => const Visitorpage());
//                         },
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                               const Color.fromARGB(255, 24, 61, 91)),
//                           shape: MaterialStateProperty.all<OutlinedBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                           ),
//                           minimumSize: MaterialStateProperty.all<Size>(
//                             const Size(double.infinity, 50),
//                           ),
//                         ),
//                         child: const Text(
//                           'Create an Account',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/functions/shared_prefence.dart';
import 'package:visitor_app_flutter/pages/forget_password.dart';
import 'package:visitor_app_flutter/pages/main_page.dart';
import 'package:visitor_app_flutter/pages/security_page.dart';
import 'package:visitor_app_flutter/pages/staff_home_page.dart';
import 'package:visitor_app_flutter/pages/visitor_page.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

final SharedPrefence cookies = SharedPrefence();

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _signIn() async {
    final formState = _formKey.currentState;
    if (formState == null) return;

    if (formState.validate()) {
      formState.save();
      if (!mounted) return;

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        print("User signed in with email: $_email");

        // Function to check the email in the given collection
        Future<DocumentSnapshot?> checkEmailInCollection(String collectionName) async {
          print("Checking email in $collectionName collection...");
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection(collectionName)
              .where('email', isEqualTo: _email)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            print("Document found in $collectionName collection.");
            return querySnapshot.docs.first;
          } else {
            print("No document found in $collectionName collection.");
            return null;
          }
        }

        DocumentSnapshot? userDoc;

        // Check in the visitors collection
        userDoc = await checkEmailInCollection('visitors');
        if (userDoc != null) {
          print("Visitor document found. Navigating to MainPage");
          await cookies.saveUserId(userCredential.user!.uid);
          if (!mounted) return;
          Get.offAll(() => Mainpage());
          return;
        }

        // Check in the staffs collection
        userDoc = await checkEmailInCollection('staffs');
        if (userDoc != null) {
          String role = userDoc.get('role');
          print("Role found: $role");
          if (role == 'staff') {
            print("Staff document found. Navigating to StaffHomePage");
            await cookies.saveUserId(userCredential.user!.uid);
            if (!mounted) return;
            Get.offAll(() => Staff_Home_Page());
            return;
          } else if (role == 'security') {
            print("Security document found. Navigating to SecurityPage");
            await cookies.saveUserId(userCredential.user!.uid);
            if (!mounted) return;
            Get.offAll(() => SecurityPage());
            return;
          } else {
            print("Unexpected role found: $role");
          }
        }

        throw FirebaseAuthException(code: 'user-not-found', message: 'No user found with this email in any collection.');

      } catch (e) {
        print("Error during sign-in: $e");
        String message = "Failed to sign in. Please try again.";
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              message = "No user found with this email in any collection.";
              break;
            case 'wrong-password':
              message = "Incorrect password. Please try again.";
              break;
            case 'invalid-email':
              message = "The email address is not valid.";
              break;
            case 'network-request-failed':
              message = "Network request failed. Please check your internet connection.";
              break;
            default:
              message = "An error occurred: ${e.message}";
          }
        } else {
          message = "An unexpected error occurred.";
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/logo.png'),
              const SizedBox(height: 150),
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value!,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: _togglePasswordVisibility,
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _signIn,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 19, 62, 97)),
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(double.infinity, 50),
                                ),
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const ForgetPassword());
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => const Visitorpage());
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 24, 61, 91)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 50),
                          ),
                        ),
                        child: const Text(
                          'Create an Account',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
