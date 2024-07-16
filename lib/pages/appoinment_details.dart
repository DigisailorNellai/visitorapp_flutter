// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AppointmentDetailsScreen extends StatelessWidget {
//   final String visitorName;
//   final DateTime appointmentDate;
//   final TimeOfDay appointmentTime;
//   final String staffName;
//   final String appointmentId;
//   final Function(bool) onAccept;
//   final Function(bool) onDecline;

//   AppointmentDetailsScreen({
//     required this.visitorName,
//     required this.appointmentDate,
//     required this.appointmentTime,
//     required this.staffName,
//     required this.appointmentId,
//     required this.onAccept,
//     required this.onDecline,
//   });

//   Future<bool> _isUserStaff() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return false;
//     }

//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//     if (!userDoc.exists) {
//       return false;
//     }

//     final userData = userDoc.data() as Map<String, dynamic>?;
//     if (userData == null) {
//       return false;
//     }

//     return userData['role'] == 'staff';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: _isUserStaff(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             appBar: AppBar(title: const Text('Appointment Details')),
//             body: const Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
//           return Scaffold(
//             body: Center(child: Text('Access Denied')),
//           );
//         }

//         return Scaffold(
//           appBar: AppBar(title: const Text('Appointment Details')),
//           body: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Visitor Name: $visitorName'),
//                 Text('Date: ${DateFormat('yyyy-MM-dd').format(appointmentDate)}'),
//                 Text('Time: ${appointmentTime.format(context)}'),
//                 Text('Staff Name: $staffName'),
//                 FutureBuilder<DocumentSnapshot>(
//                   future: FirebaseFirestore.instance
//                       .collection('appointments')
//                       .doc(appointmentId)
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     }

//                     if (snapshot.hasData && snapshot.data != null) {
//                       final appointmentData = snapshot.data!.data() as Map<String, dynamic>?;

//                       if (appointmentData == null) {
//                         return Text('No data available');
//                       }

//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Reason: ${appointmentData['reason']}'),
//                           Text('What will you be taking: ${appointmentData['whatWillYouTake']}'),
//                           Text('Is Taking Someone: ${appointmentData['isTakingSomeone'] ? 'Yes' : 'No'}'),
//                           if (appointmentData['isTakingSomeone']) Text('Number of People: ${appointmentData['numberOfPeople']}'),
//                           if (appointmentData['isTakingSomeone']) Text('Emails: ${appointmentData['emails'].join(', ')}'),
//                         ],
//                       );
//                     }

//                     return Text('No data available');
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 if (snapshot.data!) // Show buttons only if the user is staff
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           FirebaseFirestore.instance.collection('appointments').doc(appointmentId).update({'status': 'accepted'}).then((_) {
//                             onAccept(true); // Notify that the appointment is accepted
//                             Navigator.pop(context); // Close the appointment details screen
//                           });
//                         },
//                         child: const Text('Accept'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           FirebaseFirestore.instance.collection('appointments').doc(appointmentId).update({'status': 'declined'}).then((_) {
//                             onDecline(false); // Notify that the appointment is declined
//                             Navigator.pop(context); // Close the appointment details screen
//                           });
//                         },
//                         child: const Text('Decline'),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           )
//         );
//       }
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final String visitorName;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final String staffName;
  final String appointmentId;
  final Function(bool) onAccept;
  final Function(bool) onDecline;

  AppointmentDetailsScreen({
    required this.visitorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.staffName,
    required this.appointmentId,
    required this.onAccept,
    required this.onDecline,
  });

  Future<bool> _isUserStaff() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      return false;
    }

    final userData = userDoc.data() as Map<String, dynamic>?;
    if (userData == null) {
      return false;
    }

    return userData['role'] == 'staff';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserStaff(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Appointment Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          return Scaffold(
            body: Center(child: Text('Access Denied')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Appointment Details')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Visitor Name: $visitorName'),
                Text('Date: ${DateFormat('yyyy-MM-dd').format(appointmentDate)}'),
                Text('Time: ${appointmentTime.format(context)}'),
                Text('Staff Name: $staffName'),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(appointmentId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.hasData && snapshot.data != null) {
                      final appointmentData = snapshot.data!.data() as Map<String, dynamic>?;

                      if (appointmentData == null) {
                        return Text('No data available');
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reason: ${appointmentData['reason']}'),
                          Text('What will you be taking: ${appointmentData['whatWillYouTake']}'),
                          Text('Is Taking Someone: ${appointmentData['isTakingSomeone'] ? 'Yes' : 'No'}'),
                          if (appointmentData['isTakingSomeone']) Text('Number of People: ${appointmentData['numberOfPeople']}'),
                          if (appointmentData['isTakingSomeone']) Text('Emails: ${appointmentData['emails'].join(', ')}'),
                        ],
                      );
                    }

                    return Text('No data available');
                  },
                ),
                const SizedBox(height: 20),
                if (snapshot.data!) // Show buttons only if the user is staff
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('appointments').doc(appointmentId).update({'status': 'accepted'}).then((_) {
                            onAccept(true); // Notify that the appointment is accepted
                            Navigator.pop(context); // Close the appointment details screen
                          });
                        },
                        child: const Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('appointments').doc(appointmentId).update({'status': 'declined'}).then((_) {
                            onDecline(false); // Notify that the appointment is declined
                            Navigator.pop(context); // Close the appointment details screen
                          });
                        },
                        child: const Text('Decline'),
                      ),
                    ],
                  ),
              ],
            ),
          )
        );
      }
    );
  }
}

