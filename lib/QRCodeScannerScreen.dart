import 'dart:async';

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

class QRCodeScannerScreenState extends State<QRCodeScannerScreen>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  StreamSubscription<Object?>? _subscription;

  String? errorMessage;

  bool _isPopScreen = false;

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);
        unawaited(controller.start());
        return;
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
        return;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _handleBarcode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      var scannedText = barcode.rawValue;
      if (scannedText == null) {
        continue; // Skip this if scannedText is null
      }
      if (scannedText.startsWith(prefixUrl) && !_isPopScreen) {
        setState(() {
          _isPopScreen = true; // prevent repeated calling pop
        });
        debugPrint('Barcode found! $scannedText');
        scannedText = widget.prefixToken + scannedText.split(prefixUrl).last.split('?').first;
        Navigator.pop(context, scannedText); // Return the scanned text
      } else {
        // Set the error message for an invalid token
        setState(() {
          errorMessage =
              'Invalid QR Code. Please scan QR Code from a project page in Graffity Console';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            errorBuilder: (context, error, child) {
              controller.stop();
              return Container();
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
