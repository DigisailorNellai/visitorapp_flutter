// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// class StaffAppointmentsScreen extends StatefulWidget {
//   @override
//   _StaffAppointmentsScreenState createState() =>
//       _StaffAppointmentsScreenState();
// }
// class _StaffAppointmentsScreenState extends State<StaffAppointmentsScreen> {
//   Map<String, dynamic>? selectedAppointment;
//   void _acceptAppointment() {
//     // Update the appointment status in Firestore
//     FirebaseFirestore.instance
//         .collection('appointments')
//         .doc(selectedAppointment!['appointmentId'])
//         .update({'status': 'accepted'});
//     // Clear the selected appointment
//     setState(() {
//       selectedAppointment = null;
//     });
//   }
//   void _declineAppointment() {
//     TextEditingController reasonController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Decline Appointment'),
//         content: TextField(
//           controller: reasonController,
//           decoration: InputDecoration(hintText: 'Reason for cancellation'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Update the appointment status and reason in Firestore
//               FirebaseFirestore.instance
//                   .collection('appointments')
//                   .doc(selectedAppointment!['appointmentId'])
//                   .update({
//                 'status': 'declined',
//                 'declineReason': reasonController.text,
//               });
//               Navigator.of(context).pop();
//               // Clear the selected appointment
//               setState(() {
//                 selectedAppointment = null;
//               });
//             },
//             child: Text('Decline'),
//           ),
//         ],
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Staff Appointments')),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('appointments')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(
//                       child: Text('Error fetching appointments'));
//                 }
//                 final appointments = snapshot.data?.docs ?? [];
//                 return ListView.builder(
//                   itemCount: appointments.length,
//                   itemBuilder: (context, index) {
//                     final appointment = appointments[index];
//                     final appointmentData =
//                         appointment.data() as Map<String, dynamic>;
//                     return ListTile(
//                       title: Text(
//                           'Appointment with: ${appointmentData['staffId']}'),
//                       subtitle: Text('Date: ${appointmentData['date']}'),
//                       onTap: () {
//                         setState(() {
//                           selectedAppointment = appointmentData;
//                           selectedAppointment!['appointmentId'] =
//                               appointment.id;
//                         });
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           if (selectedAppointment != null)
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Staff ID: ${selectedAppointment!['staffId']}'),
//                     Text('Date: ${selectedAppointment!['date']}'),
//                     Text('Time: ${selectedAppointment!['time']}'),
//                     Text('Visitor ID: ${selectedAppointment!['visitorId']}'),
//                     Text('Reason: ${selectedAppointment!['reason']}'),
//                     Text(
//                         'What will be taken: ${selectedAppointment!['whatWillYouTake']}'),
//                     Text(
//                         'Number of people: ${selectedAppointment!['numberOfPeople']}'),
//                     Text(
//                         'Emails of people coming: ${selectedAppointment!.containsKey('emails') && selectedAppointment!['emails'] is List && (selectedAppointment!['emails'] as List<dynamic>).isNotEmpty ? (selectedAppointment!['emails'] as List<dynamic>).join(', ') : 'None'}'),
//                     Text('Status: ${selectedAppointment!['status']}'),
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: _acceptAppointment,
//                           child: Text('Accept'),
//                         ),
//                         SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: _declineAppointment,
//                           child: Text('Decline'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffAppointmentsScreen extends StatefulWidget {
  @override
  _StaffAppointmentsScreenState createState() =>
      _StaffAppointmentsScreenState();
}

class _StaffAppointmentsScreenState extends State<StaffAppointmentsScreen> {
  Map<String, dynamic>? selectedAppointment;

  void _acceptAppointment() {
    if (selectedAppointment == null) return;

    // Check if the appointment status is 'declined'
    if (selectedAppointment!['status'] == 'declined') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'This appointment has been declined and cannot be accepted.')),
      );
      return;
    }

    // Update the appointment status in Firestore
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(selectedAppointment!['appointmentId'])
        .update({'status': 'accepted'});

    // Clear the selected appointment
    setState(() {
      selectedAppointment = null;
    });
  }

  void _declineAppointment() {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Decline Appointment'),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(hintText: 'Reason for cancellation'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update the appointment status and reason in Firestore
              FirebaseFirestore.instance
                  .collection('appointments')
                  .doc(selectedAppointment!['appointmentId'])
                  .update({
                'status': 'declined',
                'declineReason': reasonController.text,
              });

              Navigator.of(context).pop();

              // Clear the selected appointment
              setState(() {
                selectedAppointment = null;
              });
            },
            child: Text('Decline'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Appointments')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error fetching appointments'));
                }
                final appointments = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    final appointmentData =
                        appointment.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(
                          'Appointment with: ${appointmentData['staffId']}'),
                      subtitle: Text('Date: ${appointmentData['date']}'),
                      onTap: () {
                        setState(() {
                          selectedAppointment = appointmentData;
                          selectedAppointment!['appointmentId'] =
                              appointment.id;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          if (selectedAppointment != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Staff ID: ${selectedAppointment!['staffId']}'),
                    Text('Date: ${selectedAppointment!['date']}'),
                    Text('Time: ${selectedAppointment!['time']}'),
                    Text('Visitor ID: ${selectedAppointment!['visitorId']}'),
                    Text('Reason: ${selectedAppointment!['reason']}'),
                    Text(
                        'What will be taken: ${selectedAppointment!['whatWillYouTake']}'),
                    Text(
                        'Number of people: ${selectedAppointment!['numberOfPeople']}'),
                    Text(
                        'Emails of people coming: ${selectedAppointment!.containsKey('emails') && selectedAppointment!['emails'] is List && (selectedAppointment!['emails'] as List<dynamic>).isNotEmpty ? (selectedAppointment!['emails'] as List<dynamic>).join(', ') : 'None'}'),
                    Text('Status: ${selectedAppointment!['status']}'),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed:
                              selectedAppointment!['status'] == 'declined'
                                  ? null // Disable button if declined
                                  : _acceptAppointment,
                          child: Text('Accept'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _declineAppointment,
                          child: Text('Decline'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
