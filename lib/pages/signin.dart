import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/pages/main_page.dart';
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
    // Replace with your preferred hashing algorithm (e.g., bcrypt)
    var bytes = utf8.encode(password); // encode the password to bytes
    var digest = sha256.convert(bytes); // hash the bytes
    return digest.toString(); // return the hashed password as string
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
        // Query Firestore for user with matching email
        var querySnapshot = await FirebaseFirestore.instance
            .collection('visitors')
            .where('email', isEqualTo: _email)
            .limit(1)
            .get();

        // Check if user exists in Firestore visitors collection
        if (querySnapshot.size > 0) {
          var userDoc = querySnapshot.docs.first;
          var storedHashedPassword = userDoc['password']; // Replace 'hashedPassword' with your actual field name
          var enteredHashedPassword = _hashPassword(_password);

          // Compare hashed passwords
          if (storedHashedPassword == enteredHashedPassword) {
            // Passwords match, navigate to the main page
            Get.to(() => Mainpage());
          } else {
            // Passwords don't match
            throw FirebaseAuthException(code: 'wrong-password');
          }
        } else {
          // User not found in Firestore visitors collection
          throw FirebaseAuthException(code: 'user-not-found');
        }
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
