import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'main_page.dart';

class VerificationPage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String profession;

  VerificationPage({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.profession,
  }) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();

  File? _imageFile; // Aadhaar image
  File? _selfieFile; // Selfie image

  Future<void> _pickAadhaarImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureAadhaarImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
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
        _selfieFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _verifyAndSave() async {
    try {
      if (_imageFile == null || _selfieFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please upload both Aadhaar image and Selfie."),
          ),
        );
        return; // Stop execution if images are missing
      }

      // Upload images to Firebase Storage
      String? aadhaarImageUrl = await _uploadImageToStorage(_imageFile, 'aadhaar');
      String? selfieUrl = await _uploadImageToStorage(_selfieFile, 'selfie');

      // Save data to Firestore
      await FirebaseFirestore.instance.collection('kyc').add({
        'aadhaar': _aadhaarController.text,
        'aadhaar_image_url': aadhaarImageUrl,
        'selfie_url': selfieUrl,
        'dob': _dateController.text,
      });

      // Navigate to the main page after successful verification
      Get.to(() => Mainpage());

    } catch (e) {
      print('Error verifying and saving: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to verify and save. Please try again."),
        ),
      );
    }
  }

  Future<String?> _uploadImageToStorage(File? image, String folderName) async {
    if (image == null) return null;

    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('$folderName/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading $folderName image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  onTap: () async {
                    final action = await showDialog<int>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Choose the source'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 0),
                            child: Text('Camera'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 1),
                            child: Text('Gallery'),
                          ),
                        ],
                      ),
                    );
                    if (action == 0) {
                      _captureAadhaarImage(); // Capture Aadhaar card photo
                    } else if (action == 1) {
                      _pickAadhaarImage(); // Pick Aadhaar card photo from gallery
                    }
                  },
                  child: Card(
                    color: Colors.grey[200],
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      padding: EdgeInsets.all(16),
                      child: _imageFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    size: 50, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  'Capture Aadhaar card',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
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
                      width: double.infinity,
                      height: 250,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _selfieFile == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey[700],
                                )
                              : Image.file(
                                  _selfieFile!,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyAndSave,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 24, 61, 91)),
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
