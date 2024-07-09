import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final String visitorName;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final Function(bool) onAccept;
  final Function(bool) onDecline;

  AppointmentDetailsScreen({
    required this.visitorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Appointment')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visitor Name: $visitorName'),
                  Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(appointmentDate)}'),
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
