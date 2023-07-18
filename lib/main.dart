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
  final Uri _githubCloneUrl =
      Uri.parse('https://github.com/Graffity-Technologies/graffity-viewer');
  final Uri _docTokenUrl = Uri.parse(
      'https://developers.graffity.tech/quick-start/graffity-console#create-access-token');

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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        _launchDocTokenUrl();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
  final _controller = TextEditingController();
  bool _submitted = false;

  static const platformAR = MethodChannel('app.graffity.ar-viewer/ar');
  Future<void> _navigateToARViewController(String accessToken) async {
    await platformAR.invokeMethod('OpenAR', {'accessToken': accessToken});
  }

  static const List<String> arMode = <String>[
    'World & Image Anchor',
    'Face Anchor'
  ];
  String? defaultArMode = arMode.first; // Default selected option

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
                  labelText: 'Enter project access token (sk...)',
                  errorText: _submitted ? _errorText : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButton<String>(
                isExpanded:  true,
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
