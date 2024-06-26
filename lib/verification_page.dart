import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Verification extends StatefulWidget {
   final String name;
  final String email;
  final String phone;
  final String profession;

   Verification({super.key,
   required this.name,
    required this.email,
    required this.phone,
    required this.profession,});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _aadhaarController = TextEditingController();

File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
   File? _image;
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
    await FirebaseFirestore.instance.collection('visitors').add({
      'name': widget.name,
      'email': widget.email,
      'phone': widget.phone,
      'profession': widget.profession,
      'aadhaar': _aadhaarController.text,
      'aadhaar_photo': _imageFile?.path,
      'selfie': _image?.path,
      'dob': _dateController.text,
    });

    // Navigate to another page or show a success message
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aadher Number',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
                SizedBox(height: 5,),
                TextFormField(
                  controller: _aadhaarController,
              decoration: InputDecoration(
                hintText: 'Enter your 12-digit Aadher Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  
                )
              ),
              
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aadher card Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
                SizedBox(height: 10,),
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
                          'Capture Aadhar card',
                          style: TextStyle(
                           fontSize: 18, 
                           color: Colors.grey
                           )),
                      ],
                    )
                  : Image.file(_imageFile!),
            ),
          ),
        ),
      ),
      SizedBox(height: 10,),

       Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selfie',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
          SizedBox(height: 5,),
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
      SizedBox(height: 10,),

       Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date of Birth',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
                SizedBox(height: 5,),
               Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          prefixIcon:  GestureDetector(
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
    SizedBox(height: 10,),
    ElevatedButton(
              
              onPressed: _verifyAndSave,
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
                'Verify',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white
                ),
                )
              ),
            ],
          ),
          ),
      ),
    );
  }
}

