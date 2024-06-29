import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/pages/verification_page.dart';

class Visitorpage extends StatelessWidget {
  const Visitorpage({Key? key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final professionController = TextEditingController();
    final passwordController = TextEditingController();

    // Function to save visitor details to Firestore
    Future<void> _saveVisitorDetails() async {
      try {
        await FirebaseFirestore.instance.collection('visitors').add({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'profession': professionController.text,
          // Add more fields as needed
        });
        // Navigate to verification page after data is saved
        Get.to(Verification(
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          profession: professionController.text,
        ));
      } catch (e) {
        print('Error saving visitor details: $e');
        // Handle errors as needed
      }
    }

    return Scaffold(
      appBar: AppBar(
        title:const Row(
            children: [
             
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'vedanta', // First text
                    style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 19, 67, 107) ,
                      fontWeight: FontWeight.bold// Adjust font size as needed
                    ),
                  ),
                   // Space between texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Center(
                  
                    child: Text(
                      'Transforming for good',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 86, 212, 90) // Increase or decrease as needed
                      ),
                    ),
                  ),
                  ],
                  )
                
                ],
              ),
            ],
          ),
        ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Enter your details to get started',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Phone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Enter your Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Profession',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: professionController,
                decoration: InputDecoration(
                  hintText: 'Enter your Profession',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your Password',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.visibility),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveVisitorDetails,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color.fromARGB(255, 24, 61, 91)),
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
                  'Create Account',
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
