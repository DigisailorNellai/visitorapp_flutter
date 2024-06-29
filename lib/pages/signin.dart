import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/pages/main_page.dart';
import 'package:visitor_app_flutter/pages/staff_home_page.dart';
import 'package:visitor_app_flutter/pages/visitor_page.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

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

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _signIn() async {
    final formState = _formKey.currentState;
    if (formState == null) {
      return;
    }

    if (formState.validate()) {
      formState.save();
      setState(() {
        _isLoading = true;
      });

      try {
        // Query Firestore for user with matching email in visitors collection
        var visitorQuerySnapshot = await FirebaseFirestore.instance
            .collection('visitors')
            .where('email', isEqualTo: _email)
            .limit(1)
            .get();

        if (visitorQuerySnapshot.size > 0) {
          var userDoc = visitorQuerySnapshot.docs.first;
          var storedHashedPassword = userDoc['password'];
          var enteredHashedPassword = _hashPassword(_password);

          if (storedHashedPassword == enteredHashedPassword) {
            Get.to(() => Mainpage());
            return;
          } else {
            throw FirebaseAuthException(code: 'wrong-password');
          }
        }

        // Query Firestore for user with matching email in staff collection
        var staffQuerySnapshot = await FirebaseFirestore.instance
            .collection('staff')
            .where('email', isEqualTo: _email)
            .limit(1)
            .get();

        if (staffQuerySnapshot.size > 0) {
          var userDoc = staffQuerySnapshot.docs.first;
          var storedHashedPassword = userDoc['password'];
          var enteredHashedPassword = _hashPassword(_password);

          if (storedHashedPassword == enteredHashedPassword) {
            Get.to(() => Staff_Home_Page()); // Navigate to StaffHomePage if email belongs to staff
            return;
          } else {
            throw FirebaseAuthException(code: 'wrong-password');
          }
        }

        // If user not found in either collection
        throw FirebaseAuthException(code: 'user-not-found');
      } catch (e) {
        print(e);
        String message = "Failed to sign in. Please try again.";
        if (e is FirebaseException) {
          switch (e.code) {
            case 'user-not-found':
              message = "No user found with this email.";
              break;
            case 'wrong-password':
              message = "Incorrect password. Please try again.";
              break;
            default:
              message = "Failed to sign in. Please try again.";
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'name@example.com',
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
                    hintText: 'password',
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _signIn,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 19, 62, 97)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(double.infinity, 50),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigate to forgot password screen or reset password flow
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => Visitorpage());
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 24, 61, 91)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 50),
                    ),
                  ),
                  child: Text(
                    'Create an account',
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
      ),
    );
  }
}
