// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class SecurityPage extends StatefulWidget {
//   @override
//   _SecurityPageState createState() => _SecurityPageState();
// }

// class _SecurityPageState extends State<SecurityPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Scan QR Code')),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       if (scanData.code != null) {
//         controller.pauseCamera();
//         _fetchAppointmentDetails(scanData.code!); // Ensure non-null value with '!'
//       } else {
//         _showError('Invalid QR code.');
//       }
//     });
//   }

//   void _fetchAppointmentDetails(String qrContent) async {
//     try {
//       final appointmentId = qrContent.split('\n')[0].split(': ')[1]; // Assuming the QR content starts with appointment ID
//       final snapshot = await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).get();

//       if (snapshot.exists) {
//         final appointmentData = snapshot.data() as Map<String, dynamic>;
//         _showAppointmentDetails(appointmentData);
//       } else {
//         _showError('Appointment not found.');
//       }
//     } catch (e) {
//       _showError('Invalid QR code.');
//     }
//   }

//   void _showAppointmentDetails(Map<String, dynamic> appointmentData) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Appointment Details'),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Visitor Name: ${appointmentData['visitorName']}'),
//               Text('Date: ${appointmentData['date']}'),
//               Text('Time: ${appointmentData['time']}'),
//               Text('Staff Name: ${appointmentData['staffName']}'),
//               Text('Reason: ${appointmentData['reason']}'),
//               Text('What will you be taking: ${appointmentData['whatWillYouTake']}'),
//               Text('Is Taking Someone: ${appointmentData['isTakingSomeone'] ? 'Yes' : 'No'}'),
//               if (appointmentData['isTakingSomeone']) Text('Number of People: ${appointmentData['numberOfPeople']}'),
//               if (appointmentData['isTakingSomeone']) Text('Emails: ${appointmentData['emails'].join(', ')}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 controller?.resumeCamera();
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showError(String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 controller?.resumeCamera();
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        controller.pauseCamera();
        _fetchAppointmentDetails(scanData.code!); // Ensure non-null value with '!'
      } else {
        _showError('Invalid QR code.');
      }
    });
  }

  void _fetchAppointmentDetails(String qrContent) async {
    try {
      final appointmentId = qrContent.split('\n')[0].split(': ')[1]; // Assuming the QR content starts with appointment ID
      final snapshot = await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).get();

      if (snapshot.exists) {
        final appointmentData = snapshot.data() as Map<String, dynamic>;
        _showAppointmentDetails(appointmentData);
      } else {
        _showError('Appointment not found.');
      }
    } catch (e) {
      _showError('Invalid QR code.');
    }
  }

  void _showAppointmentDetails(Map<String, dynamic> appointmentData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Appointment Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Visitor Name: ${appointmentData['visitorName']}'),
              Text('Date: ${appointmentData['date']}'),
              Text('Time: ${appointmentData['time']}'),
              Text('Staff Name: ${appointmentData['staffName']}'),
              Text('Reason: ${appointmentData['reason']}'),
              Text('What will you be taking: ${appointmentData['whatWillYouTake']}'),
              Text('Is Taking Someone: ${appointmentData['isTakingSomeone'] ? 'Yes' : 'No'}'),
              if (appointmentData['isTakingSomeone']) Text('Number of People: ${appointmentData['numberOfPeople']}'),
              if (appointmentData['isTakingSomeone']) Text('Emails: ${appointmentData['emails'].join(', ')}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller?.resumeCamera();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller?.resumeCamera();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
