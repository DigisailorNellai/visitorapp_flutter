// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Icon(Icons.search),
//         title: Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.notifications),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: Icon(Icons.account_circle),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text('No user logged in'));
//           }

//           return _fetchVisitorId(snapshot.data!.uid);
//         },
//       ),
//     );
//   }

//   Widget _fetchVisitorId(String userId) {
//     return FutureBuilder<DocumentSnapshot>(
//       future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return Center(child: Text('Visitor ID not found'));
//         }

//         Map<String, dynamic> data =
//             snapshot.data!.data() as Map<String, dynamic>;

//         if (!data.containsKey('visitorId')) {
//           return Center(child: Text('Visitor ID not found in user data'));
//         }

//         String visitorId = data['visitorId'];
//         return _buildUserData(visitorId);
//       },
//     );
//   }

//   Widget _buildUserData(String visitorId) {
//     if (visitorId.isEmpty) {
//       return Center(child: Text('Invalid visitor ID'));
//     }

//     return FutureBuilder<DocumentSnapshot>(
//       future: FirebaseFirestore.instance
//           .collection('visitors')
//           .doc(visitorId)
//           .get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return Center(child: Text('Visitor data not found'));
//         }

//         Map<String, dynamic> data =
//             snapshot.data!.data() as Map<String, dynamic>;

//         return SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.account_circle),
//                     SizedBox(width: 20),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           data['name'] ?? 'Name not available',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.shopping_bag),
//                             Text(
//                               data['role'] ?? 'Role not available',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30),
//                 buildInfoCard(Icons.phone, 'Phone',
//                     data['phone'] ?? 'Phone not available'),
//                 SizedBox(height: 40),
//                 buildInfoCard(Icons.mail, 'Email',
//                     data['email'] ?? 'Email not available'),
//                 SizedBox(height: 40),
//                 buildInfoCard(Icons.shopping_bag, 'Role',
//                     data['role'] ?? 'Role not available'),
//                 SizedBox(height: 40),
//                 buildInfoCard(Icons.account_balance, 'Department',
//                     data['department'] ?? 'Department not available'),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildInfoCard(IconData icon, String title, String value) {
//     return Container(
//       padding: EdgeInsets.all(7),
//       width: 340,
//       height: 80,
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 197, 196, 196),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           Icon(icon),
//           SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontSize: 18,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          if (!userSnapshot.hasData) {
            print('No user is logged in');
            return const Center(child: Text('No user is logged in'));
          }

          String userId = userSnapshot.data!.uid;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('User data not found'));
              }

              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_circle),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? 'Name not available',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.shopping_bag),
                                  Text(
                                    data['role'] ?? 'Role not available',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      buildInfoCard(Icons.phone, 'Phone',
                          data['phone'] ?? 'Phone not available'),
                      const SizedBox(height: 40),
                      buildInfoCard(Icons.mail, 'Email',
                          data['email'] ?? 'Email not available'),
                      const SizedBox(height: 40),
                      buildInfoCard(Icons.shopping_bag, 'Role',
                          data['role'] ?? 'Role not available'),
                      const SizedBox(height: 40),
                      buildInfoCard(Icons.account_balance, 'Department',
                          data['department'] ?? 'Department not available'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(7),
      width: 340,
      height: 80,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 197, 196, 196),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
