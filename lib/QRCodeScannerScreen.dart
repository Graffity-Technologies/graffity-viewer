import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

const prefixUrl = "https://viewer.graffity.app/ar/";

class QRCodeScannerScreen extends StatefulWidget {
  final String prefixToken;
  const QRCodeScannerScreen({
    Key? key,
    required this.prefixToken,
  }) : super(key: key);

  @override
  QRCodeScannerScreenState createState() => QRCodeScannerScreenState();
}

class QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                var scannedText = barcode.rawValue;
                if (scannedText == null) {
                  continue; // Skip this if scannedText is null
                }
                if (scannedText.startsWith(prefixUrl)) {
                  debugPrint('Barcode found! $scannedText');
                  scannedText =
                      widget.prefixToken + scannedText.split(prefixUrl).last;
                  Navigator.pop(
                      context, scannedText); // Return the scanned text
                } else {
                  // Set the error message for an invalid token
                  setState(() {
                    errorMessage =
                        'Invalid QR Code. Please scan QR Code from a project page in Graffity Console';
                  });
                }
              }
            },
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Darken the entire screen
            ),
          ),
          Center(
            child: Container(
              width: 300.0, // Adjust the width of the scan window as needed
              height: 300.0, // Adjust the height of the scan window as needed
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(0.4), // Darken the entire screen
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0, // Adjust the width of the white border line
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black87,
              height: 100, // Increase the height as needed
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Center(
                  child: Text(
                    errorMessage ??
                        'Scan QR Code from a project page in Graffity Console',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 32,
            left: 0,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              iconSize: 40, // Increase the size of the X button
              onPressed: () {
                // Handle the close button action here
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
