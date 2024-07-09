import 'package:flutter/material.dart';

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
            PopupMenuButton<String>(
              icon: const Icon(Icons.account_circle),
              onSelected: (value) {
                if (value == 'Option 1') {
                } else if (value == 'Option 2') {
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
      bottomNavigationBar: const NavigationBarBottom(),
    );
  }
}
