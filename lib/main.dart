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


  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const platformAR = MethodChannel('samples.flutter.dev/navigation');

//Battery
  String _batteryLevel = 'Unknown battery level.';
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

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
                  hintText: 'Enter a search term',
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
              ElevatedButton(
                onPressed: _getBatteryLevel,
                child: const Text('Get Battery Level'),
              ),
              Text(_batteryLevel),
              const SizedBox(height: 20),
              Text(_enteredText)
            ],
          ),
        ),
      ),
    );
  }
}


