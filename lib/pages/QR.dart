import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class QrCodeScreen extends StatelessWidget {
  final String qrData;

  QrCodeScreen({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your QR Code')),
      body: Center(
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
