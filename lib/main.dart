import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your access token',
                ),
              ),
              const SizedBox(height: 16),
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
              Text(_enteredText)
            ],
          ),
        ),
      ),
    );
  }
}


