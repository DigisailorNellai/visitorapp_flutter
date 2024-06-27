import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitor_app_flutter/pages/main_page.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Verification extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String profession;

  Verification({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.profession,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Add this controller

  File? _imageFile;
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureSelfie() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _verifyAndSave() async {
    try {
      // Check if the email already exists
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('visitors')
          .where('email', isEqualTo: widget.email)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isEmpty) {
        // Email does not exist, proceed with saving
        String hashedPassword = _hashPassword(_passwordController.text); // Hash the password

        await FirebaseFirestore.instance.collection('visitors').add({
          'name': widget.name,
          'email': widget.email,
          'phone': widget.phone,
          'profession': widget.profession,
          'aadhaar': _aadhaarController.text,
          'aadhaar_photo': _imageFile?.path,
          'selfie': _image?.path,
          'dob': _dateController.text,
          'password': hashedPassword, // Store hashed password in Firestore
        });

        // Navigate to the main page after successful verification
        Get.to(() => Mainpage());
      } else {
        // Email already exists, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email already exists. Please use a different email."),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to verify and save. Please try again."),
        ),
      );
    }
  }

  String _hashPassword(String password) {
    // Replace with your preferred hashing algorithm (e.g., bcrypt)
    var bytes = utf8.encode(password); // encode the password to bytes
    var digest = sha256.convert(bytes); // hash the bytes
    return digest.toString(); // return the hashed password as string
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aadhaar Number',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _aadhaarController,
                decoration: InputDecoration(
                  hintText: 'Enter your 12-digit Aadhaar Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aadhaar card Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Card(
                    color: Colors.grey[200],
                    child: Container(
                      width: 400,
                      height: 200,
                      padding: EdgeInsets.all(16),
                      child: _imageFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  'Capture Aadhaar card',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                              ],
                            )
                          : Image.file(_imageFile!),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selfie',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: GestureDetector(
                  onTap: _captureSelfie,
                  child: Card(
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: 400,
                      height: 250,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _image == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey[700],
                                )
                              : Image.file(
                                  _image!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date of Birth',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 5),
                          Text('Pick a Date'),
                        ],
                      ),
                    ),
                  ),
                  readOnly: true,
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyAndSave,
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
                  'Verify',
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
    );
  }
}
