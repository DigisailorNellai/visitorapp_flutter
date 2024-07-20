import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/pages/appoinment_details.dart';

class NavigationBarBottom2 extends StatefulWidget {
  const NavigationBarBottom2({super.key});

  @override
  State<NavigationBarBottom2> createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom2> {
  late int MyIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        child: Container(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(255, 15, 66, 107),
            onTap: (index) {
              setState(() {
                MyIndex = index;
              });
              switch (index) {
                case 0:
                  // Get.to(() => Mainpage());
                  break;
                case 1:
                  // Get.to(() => QrCodeScreen(qrData: ''));
                  break;
                case 2:
                  Get.to(() => StaffAppointmentsScreen());
                  break;
                case 3:
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
                  Icons.local_activity_outlined,
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
