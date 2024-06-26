import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/main_page.dart';
import 'package:visitor_app_flutter/signup.dart';
import 'package:visitor_app_flutter/visitor_page.dart'; // Import Get package

class NavigationBarBottom extends StatefulWidget {
  const NavigationBarBottom({super.key});

  @override
  State<NavigationBarBottom> createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom> {
  late int _selectedIndex = 0; // Renamed from MyIndex to _selectedIndex

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex), // New method to return selected page
      bottomNavigationBar: SizedBox(
        height: 70, // Adjust height as needed
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.purple,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '')
          ],
          showUnselectedLabels: false,
          showSelectedLabels: false,
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return SignUpScreen();
      case 1:
        return Visitorpage();
      case 2:
        return Mainpage();
      case 3:
        return SignUpScreen();
      default:
        return Container(); // Handle default case
    }
  }
}
