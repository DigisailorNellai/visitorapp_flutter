import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/controller/authcontroller/logout_controller.dart';

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
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(Icons.account_circle),
              onSelected: (value) {
                if (value == 'Option 1') {
                  Get.toNamed('/UserInformation');
                } else if (value == 'Option 2') {
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
      bottomNavigationBar: const NavigationBarBottom(),
    );
  }

  void setState(Null Function() param0) {}
}
