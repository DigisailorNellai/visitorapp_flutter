import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/controller/authcontroller/logout_controller.dart';

import 'package:visitor_app_flutter/functions/shared_prefence.dart';

import 'package:visitor_app_flutter/widgets/navigationbar.dart';

import '../functions/fetch_user.dart';

class UserInformation extends StatelessWidget {
  UserInformation({super.key});

  final SharedPrefence cookies = SharedPrefence();

  final UserService userService = UserService();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    // Future<dynamic>
    Future<dynamic> userId = cookies.getUserId();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.search),
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {},
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
                  // Handle My Account
                } else if (value == 'Option 2') {
                  // Handle Settings
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
      body: FutureBuilder<String?>(
          future: cookies.getUserId(),
          builder: (context, userIdSnapshot) {
            if (userIdSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (userIdSnapshot.hasError) {
              return Center(child: Text('Error: ${userIdSnapshot.error}'));
            } else if (userIdSnapshot.hasData) {
              String? userId = userIdSnapshot.data;
              if (userId == null) {
                return const Center(child: Text('No user ID available'));
              } else {
                return FutureBuilder<Map<String, dynamic>?>(
                    future: userService.getUserDetails(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        Map<String, dynamic>? userData = snapshot.data;
                        print('User details: $userData');
                        if (userData == null) {
                          return const Center(
                              child: Text('No user details available'));
                        } else {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  _buildUserHeader(userData),
                                  const SizedBox(height: 40),
                                  _buildInfoContainer(
                                    icon: Icons.phone,
                                    label: 'Phone',
                                    value:
                                        userData['phone'] ?? 'Phone not found',
                                  ),
                                  const SizedBox(height: 50),
                                  _buildInfoContainer(
                                    icon: Icons.email,
                                    label: 'Email',
                                    value:
                                        userData['email'] ?? 'Email not found',
                                  ),
                                  const SizedBox(height: 50),
                                  _buildInfoContainer(
                                    icon: Icons.shopping_bag_rounded,
                                    label: 'Profession',
                                    value: userData['profession'] ??
                                        'Profession not found',
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        return const Center(
                            child: Text('No user details available'));
                      }
                    });
              }
            } else {
              return const Center(child: Text('No user details available'));
            }
          }),
      bottomNavigationBar: const NavigationBarBottom(),
    );
  }
}

Color generateColor(String input) {
  final Random random = Random(input.hashCode);
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1,
  );
}

Widget _buildUserHeader(Map<String, dynamic> userData) {
  String userName = userData['name'] ?? 'Name not found';
  String firstLetter = userName.isNotEmpty ? userName[0] : '';
  Color backgroundColor = generateColor(userName);

  return Row(
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: backgroundColor,
        child: Text(
          firstLetter,
          style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      const SizedBox(width: 20),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Icon(Icons.shopping_bag),
              Text(
                userData['role'] ?? 'Role not found',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget _buildInfoContainer({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      //color: Colors.grey,
    ),
    height: 80,
    width: 360,
    child: Row(
      children: [
        const SizedBox(width: 10),
        Icon(icon),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );
}

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:visitor_app_flutter/controller/authcontroller/logout_controller.dart';
// import 'package:visitor_app_flutter/functions/shared_prefence.dart';
// import 'package:visitor_app_flutter/widgets/navigationbar.dart';
// import '../functions/fetch_user.dart';
// class UserInformation extends StatelessWidget {
//   UserInformation({super.key});
//   final SharedPrefService sharedPrefService = SharedPrefService();
//   final UserService userService = UserService();
//   final AuthController authController = Get.put(AuthController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const Icon(Icons.search),
//         title: Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 onChanged: (value) {},
//                 decoration: const InputDecoration(
//                   hintText: 'Search',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.notifications),
//               onPressed: () {},
//             ),
//             PopupMenuButton(
//               icon: const Icon(Icons.account_circle),
//               onSelected: (value) {
//                 if (value == 'Option 1') {
//                   // Add your implementation for Option 1
//                 } else if (value == 'Option 2') {
//                   // Add your implementation for Option 2
//                 } else if (value == 'Option 3') {
//                   authController.signOutAndNavigateToSignIn();
//                 }
//               },
//               itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                 const PopupMenuItem(
//                   value: 'Option 1',
//                   child: Text(
//                     'My Account',
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'Option 2',
//                   child: Text(
//                     'Settings',
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'Option 3',
//                   child: Text(
//                     'Logout',
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: FutureBuilder<String?>(
//         future: sharedPrefService.getUserId(),
//         builder: (context, userIdSnapshot) {
//           if (userIdSnapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (userIdSnapshot.hasError) {
//             return Center(child: Text('Error: ${userIdSnapshot.error}'));
//           } else if (userIdSnapshot.hasData) {
//             String? userId = userIdSnapshot.data;
//             if (userId == null) {
//               return const Center(child: Text('No user ID available'));
//             } else {
//               print('User ID: $userId'); // Debug print to check user ID
//               return FutureBuilder<Map<String, dynamic>?>(
//                 future: userService.getUserDetails(userId),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.hasData) {
//                     Map<String, dynamic>? userData = snapshot.data;
//                     print(
//                         'User details: $userData'); // Debug print for user data
//                     if (userData == null) {
//                       return const Center(
//                           child: Text('No user details available'));
//                     } else {
//                       return SingleChildScrollView(
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             children: [
//                               _buildUserHeader(userData),
//                               const SizedBox(height: 40),
//                               _buildInfoContainer(
//                                 icon: Icons.phone,
//                                 label: 'Phone',
//                                 value: userData['phone'] ?? 'Phone not found',
//                               ),
//                               const SizedBox(height: 50),
//                               _buildInfoContainer(
//                                 icon: Icons.email,
//                                 label: 'Email',
//                                 value: userData['email'] ?? 'Email not found',
//                               ),
//                               const SizedBox(height: 50),
//                               _buildInfoContainer(
//                                 icon: Icons.shopping_bag_rounded,
//                                 label: 'Profession',
//                                 value: userData['profession'] ??
//                                     'profession not found',
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//                   } else {
//                     return const Center(
//                         child: Text('No user details available'));
//                   }
//                 },
//               );
//             }
//           } else {
//             return const Center(child: Text('No user details available'));
//           }
//         },
//       ),
//       bottomNavigationBar: const NavigationBarBottom(),
//     );
//   }
//   Color generateColor(String input) {
//     final Random random = Random(input.hashCode);
//     return Color.fromRGBO(
//       random.nextInt(256),
//       random.nextInt(256),
//       random.nextInt(256),
//       1,
//     );
//   }
//   Widget _buildUserHeader(Map<String, dynamic> userData) {
//     String userName = userData['name'] ?? 'Name not found';
//     String firstLetter = userName.isNotEmpty ? userName[0] : '';
//     Color backgroundColor = generateColor(userName);
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 20,
//           backgroundColor: backgroundColor,
//           child: Text(
//             firstLetter,
//             style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white),
//           ),
//         ),
//         const SizedBox(width: 20),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               userName,
//               style: const TextStyle(
//                   fontFamily: 'Poppins',
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//             Row(
//               children: [
//                 const Icon(Icons.shopping_bag),
//                 Text(
//                   userData['role'] ?? 'Role not found',
//                   style: const TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//   Widget _buildInfoContainer({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Container(
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//       ),
//       height: 80,
//       width: 360,
//       child: Row(
//         children: [
//           const SizedBox(width: 10),
//           Icon(icon),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               Text(
//                 label,
//                 style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 value,
//                 style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// class SharedPrefService {
//   getUserId() {}
// }
