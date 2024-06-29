import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final String visitorName;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final Function(bool) onAccept;
  final Function(bool) onDecline;

  AppointmentDetailsScreen( {
    required this.visitorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.onAccept,
    required this.onDecline,
  });

import 'package:get/get.dart';
import 'package:visitor_app_flutter/pages/user_information.dart';
import 'package:visitor_app_flutter/widgets/navigationbar.dart';

class users extends StatefulWidget {
  const users({super.key});

  @override
  State<users> createState() => _usersState();
}

class _usersState extends State<users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Appointment')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visitor Name: $visitorName'),
                  Text('Date: ${DateFormat('yyyy-MM-dd').format(appointmentDate)}'),
                  Text('Time: ${appointmentTime.format(context)}'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => onAccept(true),
                        child: Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () => onDecline(false),
                        child: Text('Decline'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => users(),
                    ),
                  );
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
