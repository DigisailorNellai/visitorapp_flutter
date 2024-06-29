import 'package:flutter/material.dart';
import 'package:visitor_app_flutter/pages/QR.dart';
import 'package:visitor_app_flutter/pages/appointment.dart';
import 'package:visitor_app_flutter/pages/calender.dart';
import 'package:visitor_app_flutter/pages/main_page.dart';
import 'package:visitor_app_flutter/pages/user.dart';

class NavigationBarBottom extends StatefulWidget {
  const NavigationBarBottom({super.key});

  @override
  State<NavigationBarBottom> createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom> {
  late int MyIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        child: Container(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(255, 15, 66, 107),
            selectedItemColor: Colors.green,
            onTap: (index) {
              setState(() {
                MyIndex = index;
              });
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Mainpage(),
                    ),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrCodeScreen(qrData: ''),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointmentScreen(),
                    ),
                  );
                  break;
                case 3:
                  var docRef;
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => AppointmentDetailsScreen(visitorName: '', appointmentDate: , appointmentTime: appointmentTime, onAccept: onAccept, onDecline: onDecline)
                  //   ),
                  // );
                  break;
              }
            },
            currentIndex: MyIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_activity,
                  color: Colors.white,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                label: '',
              ),
            ],
            showUnselectedLabels: false,
            showSelectedLabels: false,
          ),
        ),
      ),
    );
  }
}
