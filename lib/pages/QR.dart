// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:barcode_widget/barcode_widget.dart';

// class QrCodeScreen extends StatelessWidget {
//   final String appointmentId;

//   QrCodeScreen({
//     required this.appointmentId,
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
//     return Scaffold(
//       appBar: AppBar(title: const Text('QR Code')),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance.collection('appointments').doc(appointmentId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('Appointment not found.'));
//           }

//           final appointmentData = snapshot.data!.data() as Map<String, dynamic>;

//           if (appointmentData['status'] != 'accepted') {
//             return const Center(child: Text('Awaiting staff response...'));
//           }

//           final visitorName = FirebaseAuth.instance.currentUser?.displayName ?? 'Visitor';
//           final appointmentDate = appointmentData['date'];
//           final appointmentTime = appointmentData['time'];
//           final staffName = appointmentData['staffName'];

//           final qrContent = '''
// Appointment ID: $appointmentId
// Visitor Name: $visitorName
// Date: $appointmentDate
// Time: $appointmentTime
// Staff Name: $staffName
// ''';

//           return Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 BarcodeWidget(
//                   barcode: Barcode.qrCode(),
//                   data: qrContent,
//                   width: 200,
//                   height: 200,
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Show this QR code at the security checkpoint.',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class QrCodeScreen extends StatelessWidget {
//   final String qrContent;

//   QrCodeScreen({required this.qrContent});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             QrImageView(
//               data: qrContent,
//               version: QrVersions.auto,
//               size: 200.0,
//               gapless: false,
//               backgroundColor: Colors.white,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Show this QR code at the security checkpoint.',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VisitorAppointmentsScreen extends StatefulWidget {
  final String? userId; // Optional filter criteria

  VisitorAppointmentsScreen({this.userId});

  @override
  _VisitorAppointmentsScreenState createState() =>
      _VisitorAppointmentsScreenState();
}

class _VisitorAppointmentsScreenState extends State<VisitorAppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId',
                isEqualTo:
                    widget.userId ?? '') // Apply filter if userId is provided
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching appointments'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments found'));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointmentData =
                  appointments[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Staff ID: ${appointmentData['staffId']}'),
                subtitle: Text(
                    'Date: ${appointmentData['date']} - Time: ${appointmentData['time']}'),
                trailing: Text('Status: ${appointmentData['status']}'),
                onTap: () {
                  // Handle tap if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
