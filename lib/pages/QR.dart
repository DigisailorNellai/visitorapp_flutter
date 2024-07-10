import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatelessWidget {
  final String qrData;

  QrCodeScreen({required this.qrData});

  @override
  Widget build(BuildContext context) {
    // Extract information from qrData
    List<String> qrDataList;
    String visitorId = '';
    String date = '';
    String time = '';
    String staffId = '';
    String department = '';

    try {
      qrDataList = qrData.split(',');
      visitorId = qrDataList[0].split(':')[1].trim();
      date = qrDataList[1].split(':')[1].trim();
      time = qrDataList[2].split(':')[1].trim();
      staffId = qrDataList[3].split(':')[1].trim();
      department = qrDataList[4].split(':')[1].trim();
    } catch (e) {
      // Handle parsing errors
      print('Error parsing QR data: $e');
      visitorId = 'N/A';
      date = 'N/A';
      time = 'N/A';
      staffId = 'N/A';
      department = 'N/A';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Optional: Add functionality for regenerating QR Code
              // Regenerate QR Code logic here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Appointment Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment Details:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Visitor ID: $visitorId'),
                Text('Date: $date'),
                Text('Time: $time'),
                Text('Staff ID: $staffId'),
                Text('Department: $department'),
                const SizedBox(height: 20),
                // QR Code
                Center(
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Optional: Add functionality for saving the QR code image
                    // Save QR Code logic here
                  },
                  child: const Text('Save QR Code'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
