import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/main_page.dart';
import 'package:visitor_app_flutter/visitor_page.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _register() async {
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
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        await userCredential.user!.sendEmailVerification();

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': _email,
          // Add other user info here if needed
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration successful. Verification email sent."),
            duration: Duration(seconds: 2),
          ),
        );

        _formKey.currentState!.reset();
        Get.to(Mainpage());
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create account. Please try again."),
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
      
      body:Padding(padding:EdgeInsets.all(20),
      child:Center(
        child:Form(
          key: _formKey,
          child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'name@example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  
                )
              ),
              validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'password',
                  suffixIcon:  IconButton(onPressed: _togglePasswordVisibility, 
                  icon:Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ) ),
                  border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),

                ),
                 obscureText:  !_isPasswordVisible,
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
                          onPressed: _register,
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
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        ),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                      onPressed: (){
                        Get.to(Mainpage());
                      }, 
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18, 
                      ),
                      )
                    ),
                    SizedBox(height: 20),
             ElevatedButton(
              
              onPressed: (){
                Get.to(Visitorpage()); 
              },  
              style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 24, 61, 91)),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0), // Set border radius here
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                              Size(double.infinity, 50), // Set button width and height
                            ),
                          ),
              child: Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white
                ),
                )
              )
          ]
              ),
          )
       
        
            )
          
        ),

      
      );
       
    
  }
}
