import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Uri _url =
      Uri.parse('https://github.com/Graffity-Technologies/graffity-viewer');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
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
                children: const [
                  SizedBox(height: 32),
                  Image(
                    image: AssetImage('assets/images/graffity_viewer_logo.png'),
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'AR Viewer for Graffity Console',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SubmitContainer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    _launchUrl();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Clone this app from GitHub'),
                      SizedBox(width: 5),
                      Icon(Icons.code),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitContainer extends StatelessWidget {
  const SubmitContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
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
  final _controller = TextEditingController();
  bool _submitted = false;

  static const platformAR = MethodChannel('samples.flutter.dev/navigation');
  Future<void> _navigateToARViewController(String data) async {
    await platformAR.invokeMethod('OpenAR', {'data': data});
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

    if (!text.startsWith('sk.')) {
      return 'Invalid Token';
    }
    // if (text.length < 4) {
    //   return 'Too short';
    // }
    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    final enteredValue = _controller.value.text;
    if (_errorText == null && enteredValue.startsWith('sk.')) {
      widget.onSubmit(_controller.value.text);
      _navigateToARViewController(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      // Note: pass _controller to the animation argument
      valueListenable: _controller,
      builder: (context, TextEditingValue value, __) {
        // this entire widget tree will rebuild every time
        // the controller value changes
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 80,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter your project access token',
                  // the errorText getter *depends* on _controller
                  errorText: _submitted ? _errorText : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                // the errorText getter *depends* on _controller
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
