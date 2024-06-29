import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/pages/user.dart';
import 'package:visitor_app_flutter/pages/user_information.dart';
import 'package:visitor_app_flutter/widgets/navigationbar.dart';

class calender extends StatefulWidget {
  const calender({super.key});

  @override
  State<calender> createState() => _calenderState();
}

class _calenderState extends State<calender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.account_circle),
              onSelected: (value) {
                if (value == 'Option 1') {
                  GetPage(name: '/UserScreen', page: () => UserScreen());
                } else if (value == 'Option 2') {
                  GetPage(name: '/users', page: () => users());
                } else if (value == 'Option 3') {}
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
      bottomNavigationBar: NavigationBarBottom(),
    );
  }
}
