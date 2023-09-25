import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

final _controller = TextEditingController();
const urlPrefixToken = "https://viewer.graffity.app/ar/";

void main() => runApp(MaterialApp.router(routerConfig: router));

/// This handles '/' and '/details'.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const MainApp(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (_, __) => Scaffold(
            appBar: AppBar(title: const Text('Details Screen')),
          ),
        ),
      ],
    ),
  ],
);

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Uri _githubCloneUrl =
      Uri.parse('https://github.com/Graffity-Technologies/graffity-viewer');
  final Uri _docTokenUrl = Uri.parse(
      'https://developers.graffity.tech/quick-start/graffity-console#create-access-token');
  final Uri _consoleUrl = Uri.parse("https://console.graffity.tech");

  Future<void> _launchViewerGithubUrl() async {
    if (!await launchUrl(_githubCloneUrl)) {
      throw Exception('Could not launch $_githubCloneUrl');
    }
  }

  Future<void> _launchDocTokenUrl() async {
    if (!await launchUrl(_docTokenUrl)) {
      throw Exception('Could not launch $_docTokenUrl');
    }
  }

  Future<void> _launchConsoleUrl() async {
    if (!await launchUrl(_consoleUrl)) {
      throw Exception('Could not launch $_consoleUrl');
    }
  }

  Future<void> _launchQRCodeScanner() async {
    final scannedText = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
    );

    if (scannedText != null) {
      // Handle the scanned text, e.g., update a text field
      _controller.text = scannedText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 32),
                  const Image(
                    image: AssetImage('assets/images/graffity_viewer_logo.png'),
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      _launchConsoleUrl();
                    },
                    child: const Text(
                      'AR Viewer for Graffity Console',
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
              const SubmitContainer(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        _launchQRCodeScanner(); // Call the QR code scanner screen
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons
                              .camera_alt), // Add a camera emoji using Icon widget
                          SizedBox(
                              width:
                                  8), // Add some space between the emoji and text
                          Text(
                            'Mobile Scanner',
                            style: TextStyle(
                              fontSize: 18, // Increase the font size as desired
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        _launchDocTokenUrl();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Where to get a project access token?'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        _launchViewerGithubUrl();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Clone this app from GitHub'),
                          SizedBox(width: 5),
                          Icon(
                            Icons.code,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRCodeScannerScreen extends StatelessWidget {
  final MobileScannerController cameraController = MobileScannerController();

  QRCodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                final scannedText = barcode.rawValue;
                if (scannedText == null) {
                  continue; // Skip this if scannedText is null
                }
                if (scannedText.startsWith(urlPrefixToken)) {
                  debugPrint('Barcode found! $scannedText');
                  Navigator.pop(
                      context, scannedText); // Return the scanned text
                } else {
                  // Show an error message for an invalid token
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid Token: $scannedText'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
          Center(
            child: Container(
              width: 200.0, // Adjust the width of the scan window as needed
              height: 200.0, // Adjust the height of the scan window as needed
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubmitContainer extends StatelessWidget {
  const SubmitContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextSubmitWidget(onSubmit: (value) => print(value)),
    );
  }
}

class TextSubmitWidget extends StatefulWidget {
  const TextSubmitWidget({Key? key, required this.onSubmit}) : super(key: key);
  final ValueChanged<String> onSubmit;

  @override
  State<TextSubmitWidget> createState() => _TextSubmitWidgetState();
}

class _TextSubmitWidgetState extends State<TextSubmitWidget> {
  bool _submitted = false;

  static const platformAR = MethodChannel('app.graffity.ar-viewer/ar');
  Future<void> _navigateToARViewController(
      String accessToken, String arMode) async {
    await platformAR.invokeMethod('OpenAR', {
      'accessToken': accessToken,
      'arMode': arMode,
    });
  }

  static List<String> arMode = <String>['World & Image Anchor'];
  String? defaultArMode = arMode.first; // Default ArMode option

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      arMode.add('Face Anchor');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? get _errorText {
    final text = _controller.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }

    if (!text.startsWith(urlPrefixToken)) {
      return 'Invalid Token';
    }

    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    final enteredValue = _controller.value.text;
    if (_errorText == null &&
        enteredValue.startsWith(urlPrefixToken)) {
      widget.onSubmit(_controller.value.text);
      _navigateToARViewController(_controller.text, defaultArMode!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, TextEditingValue value, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 80,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter project access token',
                  errorText: _submitted ? _errorText : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButton<String>(
                isExpanded: true,
                value: defaultArMode,
                onChanged: (String? newValue) {
                  setState(() {
                    defaultArMode = newValue;
                  });
                },
                items: arMode.map((arMode) {
                  return DropdownMenuItem(
                    value: arMode,
                    child: Text(arMode),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: _controller.value.text.isNotEmpty ? _submit : null,
                child: Text(
                  'Submit',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
