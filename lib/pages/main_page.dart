import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/controller/authcontroller/logout_controller.dart';
import 'package:visitor_app_flutter/pages/appointment.dart';
import 'package:visitor_app_flutter/pages/user_information.dart';
import 'package:visitor_app_flutter/widgets/navigationbar.dart';

class Mainpage extends StatelessWidget {
  Mainpage({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.search),
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  // Implement search functionality here
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Add notification action here
              },
            ),
            PopupMenuButton(
              icon: const Icon(Icons.account_circle),
              onSelected: (value) {
                if (value == 'Option 1') {
                  Get.to(() =>UserInformation());
                } else if (value == 'Option 2') {
                  // Add settings action here
                } else if (value == 'Option 3') {
                  authController.signOutAndNavigateToSignIn();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem(
                  value: 'Option 1',
                  child: Text(
                    'My Account',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const PopupMenuItem(
                  value: 'Option 2',
                  child: Text(
                    'Settings',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const PopupMenuItem(
                  value: 'Option 3',
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,  // Use double.infinity for responsive width
            padding: const EdgeInsets.all(16.0),  // Add padding for better layout
            child: Card(
              elevation: 5,  // Add elevation for better appearance
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),  // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),  // Add padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                      'Book Your Appointment',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 34, 159, 40),
                        fontWeight: FontWeight.bold,  // Added font weight for emphasis
                      ),
                    ),
                    const SizedBox(height: 10),
                   const Text(
                      'It\'s just a few steps',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 27, 24, 24),
                      ),
                    ),
                    const SizedBox(height: 20), 
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to BookingAppointmentScreen
                        Get.to(() => BookAppointmentScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 38, 49, 95),  // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),  // Button shape
                        ),
                        fixedSize: Size(150, 50),  // Button size
                      ),
                      child:const Text(
                        'Start Now',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavigationBarBottom(),
    );
  }
}
