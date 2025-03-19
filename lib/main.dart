import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import 'package:graffity_viewer/QRCodeScannerScreen.dart';

final _controller = TextEditingController();
const prefixToken = "Bearer ";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MaterialApp.router(routerConfig: router));
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const MainApp(initToken: ""),
      routes: [
        GoRoute(
          path: 'ar/:token',
          builder: (context, state) => MainApp(
            initToken: prefixToken + state.pathParameters["token"]!,
            latitude: double.tryParse(state.uri.queryParameters["lat"] ?? ""),
            longitude: double.tryParse(state.uri.queryParameters["long"] ?? ""),
          ),
        ),
      ],
    ),
  ],
);

class MainApp extends StatefulWidget {
  final String initToken;
  final double? latitude;
  final double? longitude;

  const MainApp({
    Key? key,
    required this.initToken,
    this.latitude,
    this.longitude,
  }) : super(key: key);

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextSubmitWidget(
                  initToken: widget.initToken,
                  onSubmit: (value) => print(""),
                ),
              ),
              Column(
                children: [
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

class TextSubmitWidget extends StatefulWidget {
  const TextSubmitWidget({
    Key? key,
    required this.onSubmit,
    required this.initToken,
  }) : super(key: key);

  final String initToken;
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

  static List<String> arModes = <String>[
    'Point Cloud & Image Anchor',
    'World & Image Anchor',
  ];
  String? defaultArMode = arModes.first; // Default ArMode option

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      var faceAnchorName = 'Face Anchor';
      if (!arModes.contains(faceAnchorName)) {
        arModes.add(faceAnchorName);
      }
    }

    if (widget.initToken != "") {
      _controller.text = widget.initToken;
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

    if (!text.startsWith(prefixToken)) {
      return 'Invalid Token';
    }

    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    final enteredValue = _controller.value.text;
    if (_errorText == null && enteredValue.startsWith(prefixToken)) {
      widget.onSubmit(_controller.value.text);
      _navigateToARViewController(_controller.text, defaultArMode!);
    }
  }

  void _showARWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AR Safety Warning'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This app uses AR. Please ensure the following before proceeding:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.supervisor_account,
                      color: Color.fromRGBO(25, 166, 182, 1)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Parental Supervision: Parental supervision is highly recommended for younger users.',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.visibility,
                      color: Color.fromRGBO(25, 166, 182, 1)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Stay Aware of Surroundings: Always be mindful of your real-world environment to avoid physical hazards.',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'By continuing, you acknowledge that you have read and understood these safety precautions.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to your AR experience screen here
                _submit();
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchQRCodeScanner() async {
    final scannedText = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRCodeScannerScreen(
          prefixToken: prefixToken,
        ),
      ),
    );

    if (scannedText != null) {
      // Handle the scanned text, e.g., update a text field
      _controller.text = scannedText;
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
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter project access token',
                errorText: _submitted ? _errorText : null,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: defaultArMode,
              onChanged: (String? newValue) {
                setState(() {
                  defaultArMode = newValue;
                });
              },
              items: arModes.map((arMode) {
                return DropdownMenuItem(
                  value: arMode,
                  child: Text(arMode),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () => {
                  if (_controller.value.text.isNotEmpty)
                    {_showARWarning(context)}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(25, 166, 182, 1),
                ),
                child: Text(
                  'Launch AR',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'OR',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: OutlinedButton(
                onPressed: () async {
                  await _launchQRCodeScanner();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      color: Color.fromRGBO(25, 166, 182, 1),
                      size: 24,
                    ), // Add a camera emoji using Icon widget
                    const SizedBox(
                        width: 8), // Add some space between the emoji and text
                    Text(
                      'Scan QR Code',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
