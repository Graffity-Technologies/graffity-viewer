import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static const platformAR = MethodChannel('samples.flutter.dev/navigation');
//AR
  final TextEditingController _textController = TextEditingController();
  String _enteredText = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _navigateToARViewController(String data) async {
    await platformAR.invokeMethod('OpenAR', {'data': data});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'AR Viewer',
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your access token',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _enteredText = _textController.text;
                    });
                    _navigateToARViewController(_textController.text);
                  },
                  child: const Text('Show AR'),
                ),
                const SizedBox(height: 20),
                // Text(_enteredText)
                const InkWell(
                  onTap: dadasdsa,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Fork here'),
                      Icon(Icons.code),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

dadasdsa(){}


// final Uri _url = Uri.parse('https://github.com/Graffity-Technologies/graffity-viewer');
// Future<void> _launchUrl() async {
//   if (!await launchUrl(_url)) {
//     throw Exception('Could not launch $_url');
//   }
// }